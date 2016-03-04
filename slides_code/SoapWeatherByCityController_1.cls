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
        if(this.selectedCountry == 'Italy'){
            this.cities.add(new SelectOption('Cagliari','Cagliari'));
        	this.cities.add(new SelectOption('Milan','Milan'));
            this.cities.add(new SelectOption('Rome','Rome'));
        }else if(this.selectedCountry == 'USA'){
            this.cities.add(new SelectOption('New York','New York'));
            this.cities.add(new SelectOption('San Francisco','San Francisco'));
        	this.cities.add(new SelectOption('Washington DC','Washington DC'));
        }else if(this.selectedCountry == 'India'){
            this.cities.add(new SelectOption('Bangalore','Bangalore'));
            this.cities.add(new SelectOption('Delhi','Delhi'));
        	this.cities.add(new SelectOption('Mumbai','Mumbai'));
            
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