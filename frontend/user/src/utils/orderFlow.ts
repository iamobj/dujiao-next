export const ORDER_FLOW_DELIVERY_TAG = '订单流交付'

const normalizeProductTag = (tag: unknown) => String(tag ?? '').trim()

export const hasOrderFlowDeliveryTag = (tags: unknown): boolean => {
  if (!Array.isArray(tags)) return false
  return tags.some((tag) => normalizeProductTag(tag) === ORDER_FLOW_DELIVERY_TAG)
}

export const getVisibleProductTags = (tags: unknown): string[] => {
  if (!Array.isArray(tags)) return []
  return tags
    .map((tag) => (typeof tag === 'string' ? tag : String(tag ?? '')))
    .filter((tag) => {
      const normalized = tag.trim()
      return normalized !== '' && normalized !== ORDER_FLOW_DELIVERY_TAG
    })
}

export const isDisplayedAutoFulfillment = (fulfillmentType: unknown, orderFlowDelivery = false): boolean => {
  return orderFlowDelivery || String(fulfillmentType ?? '').trim() === 'auto'
}
