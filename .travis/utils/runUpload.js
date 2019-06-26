const fs = require('fs');
const createWTClient = require('@wetransfer/js-sdk');

const commit = process.env.TRAVIS_COMMIT.substring(0, 6);
const jobName = process.env.TRAVIS_JOB_NUMBER;
const buildName = process.env.TRAVIS_BUILD_NUMBER;
const title = process.env.COMMIT_SUBJECT;
const author = process.env.AUTHOR_NAME;
const message = `Job: ${jobName}, Build: ${buildName}\n\n${title} (${author})`;

(async function(){
  const wtClient = await createWTClient(process.env.WT_API_KEY, {
    logger: {
      level: 'error'
    }
  });

  const appBinaryContent = await new Promise((resolve, reject) => {
    fs.readFile(
      './build/app/outputs/apk/release/app-release.apk',
      (error, data) => {
        if(error) return reject(error);
        resolve(data);
      }
    );
  });

  const transfer = await wtClient.transfer.create({
    message: message,

    files: [
      {
        name: `ApolloTV Build ${buildName} - ${commit}.apk`,
        size: appBinaryContent.length,
        content: appBinaryContent,
      }
    ]
  });

  console.log(transfer.url);
})();
