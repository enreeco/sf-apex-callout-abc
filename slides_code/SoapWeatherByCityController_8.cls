public class SoapWeatherByCityController {
    
    public List<SelectOption> cities{get;set;}
    public String selectedCountry{get;set;}
    public String selectedCity{get;set;}
    public WeatherResult wResult{get;set;}
    
    public class WeatherResult{
        /*Replicates the following response
        <CurrentWeather>
          <Location>Cagliari / Elmas, Italy (LIEE) 39-15N 009-04E 5M</Location>
          <Time>Feb 08, 2016 - 11:50 AM EST / 2016.02.08 1650 UTC</Time>
          <Wind> from the WNW (290 degrees) at 12 MPH (10 KT) (direction variable):0</Wind>
          <Visibility> greater than 7 mile(s):0</Visibility>
          <SkyConditions> mostly clear</SkyConditions>
          <Temperature> 57 F (14 C)</Temperature>
          <DewPoint> 46 F (8 C)</DewPoint>
          <RelativeHumidity> 67%</RelativeHumidity>
          <Pressure> 30.21 in. Hg (1023 hPa)</Pressure>
          <Status>Success</Status>
        </CurrentWeather>
        */
        public String Location{get;set;}
        public String Time_x{get;set;}
        public String Wind{get;set;}
        public String Visibility{get;set;}
        public String SkyConditions{get;set;}
        public String Temperature{get;set;}
        public String DewPoint{get;set;}
        public String Pressure{get;set;}
        public String RelativeHumidity{get;set;}
        public String Status{get;set;}
        
    }

    public SoapWeatherByCityController(){
        this.cities = new List<SelectOption>();
    }    
    
    public void loadCities(){
        this.wResult = null;
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
    
    public void getWeather(){
        this.wResult = null;
        if(String.isBlank(this.selectedCountry) || String.isBlank(this.selectedCity)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'Select a valid Country and City'));
            return;
        }
        
        try{
            this.wResult = new WeatherResult();
            GetWeather.GlobalWeatherSoap stub = new GetWeather.GlobalWeatherSoap();
            String weatherResult = stub.GetWeather(this.selectedCity, this.selectedCountry);
            //if no data is found the WS returns "Data not found"
            if(weatherResult == 'Data not found'){
                this.wResult = null;
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING,'Data not found'));
                return;
            }
            Dom.Document doc = new Dom.Document(); 
            doc.load(weatherResult);
            //Retrieve the root element for this document.
            Dom.XMLNode currentWeather = doc.getRootElement();
            Dom.XMLNode tmp = currentWeather.getChildElement('Location', null);
            if(tmp != null) this.wResult.Location = tmp.getText();
            tmp = currentWeather.getChildElement('Time', null);
            if(tmp != null) this.wResult.Time_x = tmp.getText();
            tmp = currentWeather.getChildElement('Wind', null);
            if(tmp != null) this.wResult.Wind = tmp.getText();
            tmp = currentWeather.getChildElement('Visibility', null);
            if(tmp != null) this.wResult.Visibility = tmp.getText();
            tmp = currentWeather.getChildElement('SkyConditions', null);
            if(tmp != null) this.wResult.SkyConditions = tmp.getText();
            tmp = currentWeather.getChildElement('Temperature', null);
            if(tmp != null) this.wResult.Temperature = tmp.getText();
            tmp = currentWeather.getChildElement('DewPoint', null);
            if(tmp != null) this.wResult.DewPoint = tmp.getText();
            tmp = currentWeather.getChildElement('RelativeHumidity', null);
            if(tmp != null) this.wResult.RelativeHumidity = tmp.getText();
            tmp = currentWeather.getChildElement('Pressure', null);
            if(tmp != null) this.wResult.Pressure = tmp.getText();
            tmp = currentWeather.getChildElement('Status', null);
            if(tmp != null) this.wResult.Status = tmp.getText();
            
        }catch(Exception e){
            this.wResult = null;
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'Unexpected error: '+e.getMessage()));
            return;
        }
    }
    
    public String debugJSONResponse{get;set;}
    public void loadCountries(){
        try{
            this.debugJSONResponse = '';
            String restResponse = RestCountriesClient.getAllCountries();
            List<Object> countriesList = (List<Object>)JSON.deserializeUntyped(restResponse);
            for(Object countryObj : countriesList){
                Map<String,Object> country = (Map<String,Object>) countryObj;
                String name = (String)country.get('name');
                String capital = (String)country.get('capital');
                Map<String,Object> translations = (Map<String,Object>)country.get('translations');
                List<Object> languages = (List<Object>)country.get('languages');
                this.debugJSONResponse += name;
                this.debugJSONResponse += '\n\t Capital: '+Capital;
                this.debugJSONResponse +='\n\t Translations: '+translations;
                this.debugJSONResponse +='\n\t Langs: '+languages;
                this.debugJSONResponse += '\n\n';
            }
        }catch(Exception e){
            this.debugJSONResponse = null;
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'Unexpected error: '+e.getMessage()));
            return;
        }
    }
}