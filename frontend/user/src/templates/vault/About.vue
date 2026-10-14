<template>
  <div class="mx-auto w-full max-w-[840px] px-6 pb-10 pt-2">
    <header class="my-8 text-center">
      <h1 class="mb-2.5 text-4xl font-extrabold">{{ heroTitle }}</h1>
      <p class="text-muted-foreground">{{ heroSubtitle }}</p>
    </header>

    <Card class="p-7 sm:p-[34px]">
      <div v-if="hasIntroduction" class="mb-9 last:mb-0">
        <p class="whitespace-pre-line text-base leading-[1.8] text-muted-foreground">{{ introductionText }}</p>
      </div>

      <div v-if="hasServices" class="mb-9 last:mb-0">
        <h2 v-if="servicesTitle" class="mb-[18px] flex items-center gap-3 text-[22px] font-bold">
          <span class="h-[26px] w-[5px] flex-none rounded-full bg-primary"></span>{{ servicesTitle }}
        </h2>
        <div class="grid gap-3.5 sm:grid-cols-2">
          <div v-for="(service, index) in serviceItems" :key="`about-service-${index}`" class="flex items-start gap-3 rounded-md border bg-secondary px-4 py-3.5">
            <Check class="mt-0.5 h-5 w-5 flex-none text-[color:var(--teal-strong)]" />
            <span class="text-[14.5px] text-muted-foreground">{{ service }}</span>
          </div>
        </div>
      </div>

      <div v-if="hasContact" class="mb-9 last:mb-0">
        <h2 v-if="contactTitle" class="mb-[18px] flex items-center gap-3 text-[22px] font-bold">
          <span class="h-[26px] w-[5px] flex-none rounded-full bg-primary"></span>{{ contactTitle }}
        </h2>
        <p v-if="contactText" class="mb-[18px] whitespace-pre-line leading-relaxed text-muted-foreground">{{ contactText }}</p>
        <div v-if="hasContactLinks" class="grid gap-3.5 sm:grid-cols-2">
          <a v-if="contactConfig?.telegram" :href="contactConfig.telegram" target="_blank" rel="noopener noreferrer" class="flex items-center justify-center gap-3 rounded-md border bg-secondary p-4 font-bold text-muted-foreground transition hover:border-hairline-strong hover:text-foreground">
            <Send class="h-6 w-6 flex-none text-[#0ea5e9]" />
            <span>Telegram</span>
          </a>
          <div v-if="contactConfig?.whatsapp" class="flex items-center justify-center gap-3 rounded-md border bg-secondary p-4 font-bold text-muted-foreground transition hover:border-hairline-strong hover:text-foreground">
            <svg viewBox="0 0 48 48" fill="none" class="h-6 w-6 flex-none" aria-hidden="true">
              <path fill-rule="evenodd" clip-rule="evenodd" d="M32.8 18.003 32.5 18C25.732 18 20 22.798 20 29c0 1.007.151 1.976.433 2.894A18 18 0 0 1 18.5 32c-1.809 0-3.54-.274-5.137-.775-.394-.123-1.828.696-3.039 1.389-.927.53-1.724.986-1.824.886-.094-.094.169-.718.476-1.448.446-1.06.986-2.346.664-2.552C6.21 27.305 4 23.866 4 20c0-6.627 6.492-12 14.5-12 7.186 0 13.151 4.326 14.3 10.003M16 16a2 2 0 1 1-4 0 2 2 0 0 1 4 0m7 2a2 2 0 1 0-4 0 2 2 0 0 1 4 0" fill="#6bb657"/>
              <path fill-rule="evenodd" clip-rule="evenodd" d="M44 29c0 3.362-1.908 6.336-4.833 8.149-.13.08.169.858.446 1.583.237.618.459 1.196.387 1.268-.075.075-.802-.327-1.571-.752-.829-.458-1.706-.942-1.871-.888-1.262.413-2.63.64-4.058.64C26.149 39 21 34.523 21 29s5.149-10 11.5-10S44 23.477 44 29m-6-3.5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0M28.5 27a1.5 1.5 0 1 0-3 0 2 2 0 0 1 3 0" fill="#6bb657"/>
            </svg>
            <span>{{ contactConfig.whatsapp }}</span>
          </div>
          <a v-if="contactConfig?.email" :href="`mailto:${contactConfig.email}`" class="flex items-center justify-center gap-3 rounded-md border bg-secondary p-4 font-bold text-muted-foreground transition hover:border-hairline-strong hover:text-foreground">
            <Mail class="h-6 w-6 flex-none text-[#f59e0b]" />
            <span>{{ t('footer.email') }}</span>
          </a>
          <a v-if="contactConfig?.support_url" :href="contactConfig.support_url" :target="contactConfig.support_url.startsWith('https://') ? '_blank' : undefined" rel="noopener noreferrer" class="flex items-center justify-center gap-3 rounded-md border bg-secondary p-4 font-bold text-muted-foreground transition hover:border-hairline-strong hover:text-foreground">
            <Headphones class="h-6 w-6 flex-none text-[#8b5cf6]" />
            <span>{{ t('footer.supportUrl') }}</span>
          </a>
        </div>
      </div>
    </Card>
  </div>
</template>

<script setup lang="ts">
import { useI18n } from 'vue-i18n'
import { Check, Send, Mail, Headphones } from 'lucide-vue-next'
import { Card } from '@/components/ui/card'
import { useAbout } from '../../composables/useAbout'

const { t } = useI18n()

const {
  contactConfig, heroTitle, heroSubtitle, introductionText, servicesTitle, contactTitle, contactText,
  serviceItems, hasIntroduction, hasServices, hasContactLinks, hasContact,
} = useAbout()
</script>
