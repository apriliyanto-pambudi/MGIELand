import { defineConfig } from 'astro/config';
import tailwind from '@astrojs/tailwind';

export default defineConfig({
  integrations: [tailwind()],
  site: 'https://mgieland.com',
  compressHTML: true,
  build: {
    inlineStylesheets: 'auto'
  }
});