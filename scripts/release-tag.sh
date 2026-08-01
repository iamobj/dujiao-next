#!/bin/sh

set -eu

script_dir=$(CDPATH= cd "$(dirname "$0")" && pwd)
repo_root=$(CDPATH= cd "$script_dir/.." && pwd)

fail() {
  printf '发布失败：%s\n' "$*" >&2
  exit 1
}

trim() {
  printf '%s' "$1" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//'
}

ask() {
  printf '%s' "$1" >&2
  IFS= read -r answer || fail '输入已结束'
  printf '%s\n' "$(trim "$answer")"
}

git_ok() {
  git -C "$repo_root" "$@" >/dev/null 2>&1
}

git_output() {
  if ! git -C "$repo_root" "$@"; then
    fail "git $* 执行失败"
  fi
}

run_git_interactive() {
  if ! git -C "$repo_root" "$@"; then
    fail "git $* 执行失败"
  fi
}

get_tag_name() {
  candidate=$(trim "${1-}")

  if [ -n "$candidate" ]; then
    printf '%s\n' "$candidate"
    return 0
  fi

  ask '请输入要发布的 tag 版本（例如 v1.0.1）：'
}

validate_tag_name() {
  tag_name=$1

  if [ -z "$tag_name" ]; then
    fail 'tag 不能为空'
  fi

  case "$tag_name" in
    *[[:space:]]*) fail 'tag 不能包含空白字符' ;;
  esac

  if ! git_ok check-ref-format "refs/tags/$tag_name"; then
    fail "\"$tag_name\" 不是合法的 tag 名称"
  fi
}

ensure_git_repo() {
  if ! git_ok rev-parse --is-inside-work-tree; then
    fail '当前目录不是 Git 仓库'
  fi
}

get_current_branch() {
  if ! git_ok symbolic-ref --quiet HEAD; then
    fail '当前处于 detached HEAD，无法自动发布 tag'
  fi

  git_output branch --show-current
}

get_upstream_branch() {
  if ! git_ok rev-parse --abbrev-ref --symbolic-full-name '@{upstream}'; then
    fail '当前分支没有配置 upstream，请先推送一次分支并建立追踪关系'
  fi

  git_output rev-parse --abbrev-ref --symbolic-full-name '@{upstream}'
}

ensure_origin_remote() {
  if ! git_ok remote get-url origin; then
    fail '未找到 origin 远端，无法推送 tag'
  fi
}

ensure_tag_not_exists() {
  tag_name=$1

  if git_ok rev-parse --verify --quiet "refs/tags/$tag_name"; then
    fail "tag $tag_name 已存在"
  fi
}

commit_if_needed() {
  status=$(git_output status --porcelain)

  if [ -z "$status" ]; then
    return 0
  fi

  printf '%s\n' '检测到未提交改动，准备先提交本地变更。'
  message=$(ask '请输入本次提交信息（留空取消发布）：')

  if [ -z "$message" ]; then
    fail '已取消：存在未提交改动但未提供 commit message'
  fi

  run_git_interactive add -A
  run_git_interactive commit -m "$message"
}

push_branch_if_needed() {
  upstream_branch=$1
  counts=$(git_output rev-list --left-right --count "$upstream_branch...HEAD")
  behind=$(printf '%s\n' "$counts" | awk '{print $1}')
  ahead=$(printf '%s\n' "$counts" | awk '{print $2}')

  case "$behind" in
    ''|*[!0-9]*) fail '无法判断当前分支与远端分支的提交差异' ;;
  esac

  case "$ahead" in
    ''|*[!0-9]*) fail '无法判断当前分支与远端分支的提交差异' ;;
  esac

  if [ "$behind" -gt 0 ]; then
    fail "当前分支落后远端 $behind 个提交，请先同步代码再发布"
  fi

  if [ "$ahead" -gt 0 ]; then
    printf '检测到 %s 个未 push 提交，先推送当前分支到 %s。\n' "$ahead" "$upstream_branch"
    run_git_interactive push
    return 0
  fi

  printf '%s\n' '当前分支没有未 push 的提交。'
}

create_and_push_tag() {
  tag_name=$1

  printf '开始创建 tag %s。\n' "$tag_name"
  run_git_interactive tag -a "$tag_name" -m "Release $tag_name"

  printf '开始推送 tag %s 到 origin。\n' "$tag_name"
  run_git_interactive push origin "$tag_name"
}

main() {
  ensure_git_repo

  tag_name=$(get_tag_name "${1-}")
  validate_tag_name "$tag_name"
  ensure_tag_not_exists "$tag_name"
  ensure_origin_remote

  branch_name=$(get_current_branch)
  upstream_branch=$(get_upstream_branch)

  printf '当前分支：%s\n' "$branch_name"
  printf '远端分支：%s\n' "$upstream_branch"
  printf '%s\n' 'Tag 目标远端：origin'

  commit_if_needed
  push_branch_if_needed "$upstream_branch"
  create_and_push_tag "$tag_name"

  printf '发布完成：%s\n' "$tag_name"
}

main "${1-}"
