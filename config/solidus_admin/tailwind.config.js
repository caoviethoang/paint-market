const { execSync } = require('child_process')
const adminRoot = execSync('bundle show solidus_admin').toString().trim()
const solidusAdmin = require(`${adminRoot}/config/tailwind.config.js`)

module.exports = {
  // Read how to use TailwindCSS presets: https://tailwindcss.com/docs/presets.
  presets: [solidusAdmin],

  content: [
    // Include paths coming from SolidusAdmin.
    ...solidusAdmin.content,

    // Include paths to your own components.
    `${__dirname}/../../app/components/admin/**/*`,
    `${__dirname}/../../app/components/solidus_admin/**/*`,
    `${__dirname}/../../app/views/spree/admin/**/*`,
    `${__dirname}/../../app/views/solidus_admin/**/*`,
    `${__dirname}/../../app/views/layouts/solidus_admin/**/*`,
    `${__dirname}/../../app/views/admin/**/*`,
    
    // Include all ERB files that might contain Tailwind classes
    `${__dirname}/../../app/views/**/*.erb`,
    `${__dirname}/../../app/components/**/*.erb`,
    
    // Include JavaScript files
    `${__dirname}/../../app/javascript/**/*.js`,
    `${__dirname}/../../app/assets/javascripts/**/*.js`,
  ],
}
