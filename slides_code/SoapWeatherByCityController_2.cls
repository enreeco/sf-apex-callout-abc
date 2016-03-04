public class SoapWeatherByCityController {
    
    public List<SelectOption> cities{get;set;}
    public String selectedCountry{get;set;}
    public String selectedCity{get;set;}

    public SoapWeatherByCityController(){
        this.cities = new List<SelectOption>();
    }    
    
    public void loadCities(){
        this.cities = new List<SelectOption>();
        if(String.isBlank(this.selectedCountry)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'Select a valid Country'));
            return;
        }
        try{
            GetWeather.GlobalWeatherSoap stub = new GetWeather.GlobalWeatherSoap();
            String result = stub.GetCitiesByCountry(this.selectedCountry);
            this.cities.add(new SelectOption(result,result));
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'Unexpected error: '+e.getMessage()));
            return;
        }
    }
    
    public void getWeather(){
        if(String.isBlank(this.selectedCountry) || String.isBlank(this.selectedCity)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'Select a valid Country and City'));
            return;
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING,'No data'));
        
    }
}