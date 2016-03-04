public class ChainedContinuationController {
    
    public Country selectedCountry{get;Set;}
    public List<String> sameCurrencyCountries{get;Set;}
    private String requestLabel;
    
    //helper to parse the JSON requests
	public class Country{
        public String name{get;set;}
        public List<String> currencies{get;set;}
    } 
    
    public Object startChainContinuation1(){
        Continuation cnt = new Continuation(60);
        cnt.continuationMethod = 'processChainContinuation1';
        
        HttpRequest req = RestCountriesClient.prepareGetAllCountriesRequest();
        this.requestLabel = cnt.addHttpRequest(req);    
        
        return cnt;
    }
    
    public Object processChainContinuation1(){
        try{
            HttpResponse response = Continuation.getResponse(this.requestLabel);
            
            List<Country> countriesList = (List<Country>)JSON.deserialize(response.getBody(), List<Country>.class);
            //randomize a country
            Integer randomIndex = (Integer) (Math.random() * (Double)(countriesList.size()-1));
            
            this.selectedCountry = countriesList[randomIndex];
            
            //second continuation
            Continuation cnt = new Continuation(60);
            cnt.continuationMethod = 'processChainContinuation2';
            
            HttpRequest req = RestCountriesClient.prepareGetAllCountriesByCurrencyRequest(this.selectedCountry.currencies[0]);
            this.requestLabel = cnt.addHttpRequest(req);  
            
            return cnt;
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'Unexpected error: '+e.getMessage()));
            return null;
        }
    }
    
    public Object processChainContinuation2(){
        try{
            HttpResponse response = Continuation.getResponse(this.requestLabel);
            
            this.sameCurrencyCountries = new List<String>();
            List<Country> countriesList = (List<Country>)JSON.deserialize(response.getBody(), List<Country>.class);
            for(Country cnt : countriesList){
                this.sameCurrencyCountries.add(cnt.name);
            }
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'Unexpected error: '+e.getMessage()));
        }
        return null;
    }
}