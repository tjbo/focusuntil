const os = require('os')
const { cat, exec } = require('shelljs')

const APP_REF = 'com.adobe.Photoshop'
const isMacOs = os.platform() === 'darwin'

exec('system_profiler SPApplicationsDataType -json -detailLevel mini').to(
  'test.json',
)

const config = require('./test.json')
const thing2 = config['SPApplicationsDataType']
  .filter((_thing) => {
    const regex = /\/Application/g
    console.log(_thing.path.match(regex))
    return !!_thing.path.match(regex)
  })
  .filter((_thing) => {
    const regex = /\/Library\//g
    return !!!_thing.path.match(regex)
  })
  .filter((_thing) => {
    const regex = /\/Utilities/g
    return !!!_thing.path.match(regex)
  })
  .map((thing) => {
    console.log(thing.path)
  })

console.log(thing2.length)

/**
 * Helper function to shell out various commands.
 * @returns {String} The result of the cmd minus the newline character.
 */
function shellOut(cmd) {
  return exec(cmd, { silent: true }).stdout.replace(/\n$/, '')
}

if (isMacOs) {
  const appName = shellOut(`osascript -e 'tell application "Finder" \
      to get displayed name of application file id "${APP_REF}"'`)

  if (appName) {
    const version = shellOut(`osascript -e 'tell application "Finder" \
        to get version of application file id "${APP_REF}"'`).split(' ')[0]

    console.log(version) // Log the version to console.

    shellOut(`open -a "${appName}"`) // Launch the application.
  } else {
    console.log('Photoshop is not installed')
  }
}
