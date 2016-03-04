public class RestCountriesClient {
    
    private static final String CALLOUT_DOMAIN = 'https://restcountries.eu';
    private static final String CALLOUT_DOMAIN_NAMED_CRED = 'callout:Rest_Countries';
    
    public static String getAllCountries(){
        Http client = new Http();
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(CALLOUT_DOMAIN_NAMED_CRED+'/rest/v1/all');
        req.setMethod('GET');
        req.setTimeout((Integer)WebserviceConfiguration__c.getInstance('RestCountries').Timeout__c);
        HttpResponse res = client.send(req);
        return res.getBody();
    }
    
    public static HttpRequest prepareGetAllCountriesRequest(){
        Http client = new Http();
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(CALLOUT_DOMAIN+'/rest/v1/all');
        req.setMethod('GET');
        req.setTimeout((Integer)WebserviceConfiguration__c.getInstance('RestCountries').Timeout__c);
        return req;
    }
    
    public static HttpRequest prepareGetAllCountriesByCurrencyRequest(String currString){
        Http client = new Http();
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(CALLOUT_DOMAIN+'/rest/v1/currency/'+currString);
        req.setMethod('GET');
        req.setTimeout((Integer)WebserviceConfiguration__c.getInstance('RestCountries').Timeout__c);
        return req;
    }
}