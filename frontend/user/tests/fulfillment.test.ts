import test from 'node:test'
import assert from 'node:assert/strict'
import {
  ORDER_FLOW_DELIVERY_TAG,
  getVisibleProductTags,
  hasOrderFlowDeliveryTag,
  isDisplayedAutoFulfillment,
} from '../src/utils/orderFlow.ts'
import { fulfillmentTypeLabel } from '../src/utils/fulfillment.ts'

test('order-flow delivery tag is detected only in arrays', () => {
  assert.equal(hasOrderFlowDeliveryTag([ORDER_FLOW_DELIVERY_TAG]), true)
  assert.equal(hasOrderFlowDeliveryTag(['普通标签', ` ${ORDER_FLOW_DELIVERY_TAG} `]), true)
  assert.equal(hasOrderFlowDeliveryTag([]), false)
  assert.equal(hasOrderFlowDeliveryTag(null), false)
  assert.equal(hasOrderFlowDeliveryTag('订单流交付'), false)
  assert.equal(hasOrderFlowDeliveryTag({ tag: ORDER_FLOW_DELIVERY_TAG }), false)
})

test('internal order-flow tag is hidden while other tags remain visible', () => {
  assert.deepEqual(
    getVisibleProductTags(['限时', ORDER_FLOW_DELIVERY_TAG, '  ', ' 数字商品 ']),
    ['限时', ' 数字商品 '],
  )
  assert.deepEqual(getVisibleProductTags(undefined), [])
  assert.deepEqual(getVisibleProductTags('not-an-array'), [])
})

test('order-flow delivery displays manual fulfillment as auto', () => {
  assert.equal(isDisplayedAutoFulfillment('manual', true), true)
  assert.equal(isDisplayedAutoFulfillment('auto', false), true)
  assert.equal(isDisplayedAutoFulfillment('manual', false), false)
  assert.equal(isDisplayedAutoFulfillment('', false), false)
  assert.equal(isDisplayedAutoFulfillment(undefined, true), true)
})

test('fulfillment labels preserve existing types and support display-only auto override', () => {
  const t = (key: string) => ({
    'orderDetail.fulfillmentTypes.manual': '人工交付',
    'orderDetail.fulfillmentTypes.auto': '自动交付',
  }[key] || key)

  assert.equal(fulfillmentTypeLabel(t, 'auto'), '自动交付')
  assert.equal(fulfillmentTypeLabel(t, 'manual'), '人工交付')
  assert.equal(fulfillmentTypeLabel(t, 'upstream'), '人工交付')
  assert.equal(fulfillmentTypeLabel(t, 'manual', 'orderDetail', true), '自动交付')
  assert.equal(fulfillmentTypeLabel(t, undefined), '-')
  assert.equal(fulfillmentTypeLabel(t, ''), '-')
})
