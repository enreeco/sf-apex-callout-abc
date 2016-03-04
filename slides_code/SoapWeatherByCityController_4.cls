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
            
            //parse the result with the following structure:
            //<NewDataSet>
            //  <Table>
            //      <Country>CountryName</Country>
            //      <City>CityName</City>
            //  </Table>
            //  . . .
            //</NewDataSet>
            Dom.Document doc = new Dom.Document();
            doc.load(result);
            //Retrieve the root element for this document.
            Dom.XMLNode newDataSet = doc.getRootElement();
            List<Dom.XmlNode> tables = newDataSet.getChildElements();
            for(Dom.XmlNode table : tables){
                String city = table.getChildElement('City', null).getText();
                this.cities.add(new SelectOption(city,city));
            }
            this.cities.sort();
            if(this.cities.isEmpty()){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'No city found'));
            }
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'Unexpected error: '+e.getMessage()));
            return;
        }
    }
    

    public String weatherResult{get;set;}

    public void getWeather(){
        if(String.isBlank(this.selectedCountry) 
            || String.isBlank(this.selectedCity)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,
                'Select a valid Country and City'));
            return;
        }

        try{
            GetWeather.GlobalWeatherSoap stub = new GetWeather.GlobalWeatherSoap();
            this.weatherResult = stub.GetWeather(this.selectedCity, 
                this.selectedCountry);
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,
                'Unexpected error: '+e.getMessage()));
            return;
        }
    }
}