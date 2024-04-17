const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const fetch = require('node-fetch');

const app = express();
const port = 3000;

// Object of allowed coupon codes with index as key
const allowedCouponCodes = {
  0: "71905041-ad22-49f2-9dca-0a885e692905",
  1: "76b9c18f-d6c2-47cd-bb02-6d04c2a0ac3e",
  2: "5b70a2ec-058e-4632-bc98-23a57f24373f",
  3: "ccaecb3a-0228-4530-95a0-d292cb3058cc",
  4: "5988cfd1-d089-497c-b059-d2704810da18",
  5: "45ec2dfc-c7d3-435b-a0bd-d1482554549d",
  6: "6debb7db-1c14-4057-ad4c-5012b23cfd72",
  7: "4bbcc702-8e4c-44e1-965f-aafb91543a0d",
  8: "f646f460-5198-48de-9102-fc7f63779a19",
  9: "bdd4e803-6ac0-4f5f-8710-3ac5f2ec9f24",
  10: "2cd88679-e443-4d9b-81c5-1acb4ca1fdef"
};

const listOfItems = {
  1: "Tech tip",
  2: "a sticker",
  3: "riddle",
  4: "5 minute hangout",
  5: "Five",
  6: "Six",
  7: "Seven"
}

app.use(cors());
app.use(bodyParser.json());

app.post('/purchase', async (req, res) => {
    const purchaseData = req.body;
    console.log('Received purchase data:', purchaseData);

    // Check if the "token" is named "couponCode" and validate against allowed codes
    const couponCode = purchaseData.couponCode || purchaseData.token;
    const index = Object.keys(allowedCouponCodes).find(key => allowedCouponCodes[key] === couponCode);

    if (index) {
        // Valid coupon code
        console.log('Valid coupon code:', couponCode, 'Index:', index);

        // Additional processing if needed
        await callWebhook({ index, purchaseData });

        res.json({ message: 'Purchase data received successfully!', index: parseInt(index) });
    } else {
        // Invalid coupon code
        console.log('Invalid coupon code:', couponCode);

        res.status(403).json({ error: 'Invalid coupon code' });
    }
});

async function callWebhook(data) {
  // https://birdie0.github.io/discord-webhooks-guide/discord_webhook.html

  const webhookURL = 'https://discord.com/api/webhooks/1234567/abcdefg';

  var params = {
    username: "Shop Bot",
    embeds: [
      {
        "title": `Purchase from team #${data.index}`,
        "color": 11403055,
        "description": `Team ${data.index} purchased ${listOfItems[data.purchaseData.item]}`
      }
    ] 
  }

  try {
      const response = await fetch(webhookURL, {
          method: 'POST',
          headers: {
              'Content-Type': 'application/json',
          },
          body: JSON.stringify(params)
      });

      if (response.ok) {
          console.log('Webhook called successfully');
      } else {
          console.log(response);
          console.error('Error calling webhook:', response.statusText);
      }
  } catch (error) {
      console.error('Error calling webhook:', error.message);
  }
}


app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});
