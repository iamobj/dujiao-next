<template>
  <div class="about-page min-h-screen bg-background text-foreground pt-20 pb-16">
    <div class="container mx-auto max-w-4xl px-4">
      <div class="mt-12 mb-16 text-center">
        <h1 class="mb-6 text-4xl font-black tracking-tight text-foreground md:text-6xl">{{ heroTitle }}</h1>
        <p class="mx-auto max-w-2xl border-b pb-8 text-lg leading-relaxed text-muted-foreground">{{ heroSubtitle }}</p>
      </div>

      <Card class="relative overflow-hidden rounded-3xl p-8 shadow-2xl backdrop-blur-xl md:p-12">
        <div v-if="hasIntroduction" class="mb-12">
          <p class="whitespace-pre-line text-lg leading-relaxed text-muted-foreground">{{ introductionText }}</p>
        </div>

        <div v-if="hasServices" class="mb-12">
          <h2 v-if="servicesTitle" class="mb-6 flex items-center gap-3 text-2xl font-bold text-foreground">
            <span class="h-8 w-1.5 rounded-full bg-primary"></span>
            {{ servicesTitle }}
          </h2>
          <div class="grid grid-cols-1 gap-4 md:grid-cols-2">
            <div v-for="(service, index) in serviceItems" :key="`about-service-${index}`" class="flex items-start gap-3 rounded-xl border bg-secondary p-4 transition-colors">
              <Check class="mt-0.5 h-6 w-6 flex-shrink-0 text-primary" />
              <span class="text-muted-foreground">{{ service }}</span>
            </div>
          </div>
        </div>

        <div v-if="hasContact">
          <h2 v-if="contactTitle" class="mb-6 flex items-center gap-3 text-2xl font-bold text-foreground">
            <span class="h-8 w-1.5 rounded-full bg-primary"></span>
            {{ contactTitle }}
          </h2>
          <p v-if="contactText" class="mb-8 whitespace-pre-line text-muted-foreground">{{ contactText }}</p>
          <div v-if="hasContactLinks" class="grid grid-cols-1 gap-4 sm:grid-cols-2">
            <a v-if="contactConfig?.telegram" :href="contactConfig.telegram" target="_blank" rel="noopener noreferrer" class="group flex items-center justify-center space-x-3 rounded-xl border bg-secondary px-6 py-4 text-muted-foreground transition-colors hover:text-foreground">
              <Send class="h-6 w-6 text-sky-500" />
              <span class="font-bold">Telegram</span>
            </a>
            <div v-if="contactConfig?.whatsapp" class="group flex items-center justify-center space-x-3 rounded-xl border bg-secondary px-6 py-4 text-muted-foreground transition-colors hover:text-foreground">
              <svg class="h-6 w-6 shrink-0" fill="none" viewBox="0 0 48 48" aria-hidden="true">
                <path fill-rule="evenodd" clip-rule="evenodd" d="M32.8 18.003 32.5 18C25.732 18 20 22.798 20 29c0 1.007.151 1.976.433 2.894A18 18 0 0 1 18.5 32c-1.809 0-3.54-.274-5.137-.775-.394-.123-1.828.696-3.039 1.389-.927.53-1.724.986-1.824.886-.094-.094.169-.718.476-1.448.446-1.06.986-2.346.664-2.552C6.21 27.305 4 23.866 4 20c0-6.627 6.492-12 14.5-12 7.186 0 13.151 4.326 14.3 10.003M16 16a2 2 0 1 1-4 0 2 2 0 0 1 4 0m7 2a2 2 0 1 0-4 0 2 2 0 0 1 4 0" fill="#6bb657"/>
                <path fill-rule="evenodd" clip-rule="evenodd" d="M44 29c0 3.362-1.908 6.336-4.833 8.149-.13.08.169.858.446 1.583.237.618.459 1.196.387 1.268-.075.075-.802-.327-1.571-.752-.829-.458-1.706-.942-1.871-.888-1.262.413-2.63.64-4.058.64C26.149 39 21 34.523 21 29s5.149-10 11.5-10S44 23.477 44 29m-6-3.5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0M28.5 27a1.5 1.5 0 1 0-3 0 2 2 0 0 1 3 0" fill="#6bb657"/>
              </svg>
              <span class="font-bold">{{ contactConfig.whatsapp }}</span>
            </div>
            <a v-if="contactConfig?.email" :href="`mailto:${contactConfig.email}`"
              class="group flex items-center justify-center space-x-3 bg-secondary border text-muted-foreground px-6 py-4 rounded-xl transition-colors hover:text-foreground">
              <Mail class="w-6 h-6 text-amber-500" />
              <span class="font-bold">{{ t('footer.email') }}</span>
            </a>
            <a v-if="contactConfig?.support_url" :href="contactConfig.support_url"
              :target="contactConfig.support_url.startsWith('https://') ? '_blank' : undefined" rel="noopener noreferrer"
              class="group flex items-center justify-center space-x-3 bg-secondary border text-muted-foreground px-6 py-4 rounded-xl transition-colors hover:text-foreground">
              <Headphones class="w-6 h-6 text-violet-500" />
              <span class="font-bold">{{ t('footer.supportUrl') }}</span>
            </a>
          </div>
        </div>
      </Card>
    </div>
  </div>
</template>

<script setup lang="ts">
import { useI18n } from 'vue-i18n'
import { Check, Send, Mail, Headphones } from 'lucide-vue-next'
import { Card } from '@/components/ui/card'
import { useAbout } from '../composables/useAbout'

const { t } = useI18n()

const {
  contactConfig, heroTitle, heroSubtitle, introductionText, servicesTitle, contactTitle, contactText,
  serviceItems, hasIntroduction, hasServices, hasContactLinks, hasContact,
} = useAbout()
</script>
