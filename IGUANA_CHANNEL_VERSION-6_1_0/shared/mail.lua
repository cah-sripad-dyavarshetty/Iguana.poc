local mail =  {}

function mail.send_email()
      -- Set up the parameters to be used with sending an email
   local smtpparams={
      header = {To = 'naveen.chandaluri@cordlogistics.com'; 
                From = 'devinternalsmtpauth.cardinalhealth.net'; 
                Date = '';
                Subject = 'Test Subject';},
      username = 'devinternalsmtpauth.cardinalhealth.net',
      password = '8ChAhR#HKLdzr4d',
      server = 'smtp://devinternalsmtpauth.cardinalhealth.net:25', 
      -- note that the "to" param is actually what is used to send the email, 
      -- the entries in header are only used for display. 
      -- For instance, to do Bcc, add the address in the  'to' parameter but 
      -- omit it from the header.
      to = {'naveen.chandaluri@cordlogistics.com'},
      from = 'devinternalsmtpauth.cardinalhealth.net',
      body = 'This is the test body of the email',
      use_ssl = 'try',
      --live = true -- uncomment to run in the editor
   } 
  net.smtp.send(smtpparams)
end
return mail
