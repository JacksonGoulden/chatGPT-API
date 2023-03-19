import openai
import boto3
import json

def lambda_handler(event, context):
  
  openai.organization = "org-uDYGnAtAj6JZSVli5KOYHmLa"
  openai.api_key = "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"
    
  text_to_ask = event["headers"]["gpt-phrase"]
  
  completion = openai.ChatCompletion.create(
  model="gpt-3.5-turbo",
  messages=[
    {"role": "user", "content": text_to_ask}
    ]
  )
  
  print(json.dumps(event))
  
  notification = str(completion.choices[0].message.content)
  
  # client = boto3.client('sns')
  # response = client.publish(
  #   TargetArn = "arn:aws:sns:ap-southeast-2:396735513237:TextFromGPT",
  #   Message = json.dumps({'default': notification}),
  #   MessageStructure = 'json'
  #   )
  
  print(event["headers"]["gpt-phrase"])
  
  return {
    'statusCode': 200,
    'body': notification
   }