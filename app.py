import openai
import json

def lambda_handler(event, context):
  
  # Log the event details
  print(json.dumps(event))
  
  # Log the phrase given by the SIRI user
  print(event["headers"]["gpt-phrase"])
  
  # Sets openai credentials
  openai.organization = "INSERT ORGINIZATION NAME HERE" # eg "org-jhvfdshfvadshvsdauhvasdhvhvsajf"
  openai.api_key = "INSERT KEY FROM OPENAI HERE" # eg "sk-shdygfADSAWDASDAWDuyhfgdsfgsfdh"
  
  # Retrieves the phrase given to siri through the "gpt-phrase" header and saves it as a variable
  text_to_ask = event["headers"]["gpt-phrase"]
  
  # Creates a request to chatGPT 
  completion = openai.ChatCompletion.create(
  model="gpt-3.5-turbo", # Set the AI model you wish to use. See here for a list https://platform.openai.com/docs/models
  messages=[
    {"role": "user", "content": text_to_ask} # The body of the message, with the content to send as the variable saved from SIRI
    ]
  )
  
  # Save the chatGPT response as a variable. This will be returned
  notification = str(completion.choices[0].message.content)
  
  # Return a 200 success code and the chatGPT response as the body
  return {
    'statusCode': 200,
    'body': notification
   }
