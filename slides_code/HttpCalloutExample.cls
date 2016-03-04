public class HttpCalloutExample {
    
    private static final String CALLOUT_DOMAIN = 'callout:Request_Bin';
    public class CustomException extends Exception{}
    
    public static String makeCall(String binId){
        Http client = new Http();
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(CALLOUT_DOMAIN+'/'+binId);
        req.setMethod('POST');
        req.setTimeout(10000);
        req.setHeader('Custom-Header', 'Custom value + {!$Credential.AuthorizationMethod}');
        String body = 'Username: {!$Credential.Username}';
        body += '\nSending composite JSON: \n';
        body += JSON.serializePretty([Select Id, Name From Account order by Name limit 10]);
        req.setBody(body);
        
        HttpResponse res = client.send(req);
        if(res.getStatusCode() != 200){
            throw new CustomException('Unexpected response from server: code '+res.getStatusCode());
        }
        return res.getBody();
    }
}