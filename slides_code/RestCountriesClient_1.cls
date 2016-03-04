public class RestCountriesClient {
    
    private static final String CALLOUT_DOMAIN = 'callout:Rest_Countries';
    
    public static String getAllCountries(){
        Http client = new Http();
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(CALLOUT_DOMAIN+'/rest/v1/all');
        req.setMethod('GET');
        req.setTimeout((Integer)WebserviceConfiguration__c
            .getInstance('RestCountries').Timeout__c);
        
        HttpResponse res = client.send(req);
        return res.getBody();
    }
}