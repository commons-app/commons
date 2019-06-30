const fs = require('fs');

function asObject(inputArray, value = ""){
  let obj = {};
  inputArray.forEach((entry) => obj[entry] = value);
  return obj;
}

// This should be executed from the project root directory.
const lang_en = JSON.parse(fs.readFileSync("res/values/strings_en.arb"));

try {

  // Determine and load in the target language.
  let targetLangName;
  if(process.argv.length > 2) targetLangName = process.argv[2];
  const targetLang = JSON.parse(fs.readFileSync(`res/values/${targetLangName}`));

  console.log(`Comparing ${targetLangName} to strings_en.arb...`);
  console.log();

  // Load the required keys and the translation's keys.
  let missingKeys = Object.keys(lang_en);
  let targetKeys = Object.keys(targetLang);

  // If the translation has a key, remove it from missingKeys
  // because it's not missing.
  for(let index in targetKeys){
    let targetKey = targetKeys[index];
    let targetKeyIndex = missingKeys.indexOf(targetKey);

    if(targetKeyIndex !== -1){
      missingKeys.splice(targetKeyIndex, 1);
    }
  }

  if(missingKeys.length > 0){
    // This translation is missing keys.
    console.error(`${targetLangName} is missing the folllowing translations:`);
    console.error(`They should be added to the bottom of the file.`);
    console.error("");
    console.log(JSON.stringify(asObject(missingKeys), null, '\t')
      .replace("{\n", "")
      .replace("\n}", "")
    );
    process.exit(1);
  }

  console.log(`${targetLangName} has passed all of the translation file tests.`);
  process.exit(0);

}catch(ex){
  console.error("Failed to read translation file: " + (process.argv.length > 2 ? process.argv[2] : "(missing)"));
  console.error("Is the translation file valid and located in /res/values?");
  console.error("");
  console.error(ex);
  process.exit(1);
}
