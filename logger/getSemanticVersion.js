const fs = require('fs')
  
fs.readFile('BuildNo.txt', (err, data) => {
    if (err) throw err;

    let version = data.toString().split('.')

    let firstSplit = version[0].split('-')
    let first
    if (firstSplit.length == 2)
        first = parseInt(firstSplit[1])
    else 
        first = parseInt(version[0])

    let second = parseInt(version[1])
    let third =  parseInt(version[2])
    console.log('Input: ' + data.toString());
    var finalVersion = `${first}.${second}.${third}`

    fs.writeFile('BuildNo-Updated.txt', finalVersion, error => {
        if (error)
            console.log('Error writing to the file: ' + error)
        else 
            console.log('Output:' + finalVersion)
    })
})
