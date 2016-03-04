@isTest
private class SoapWeatherByCityControllerTest {
    
    @testSetup
    private static void setupObjects(){
        insert new WebserviceConfiguration__c(Name='GetWeather', 
                                              Timeout__c = 10000);
    }
    
    private static testmethod void test_unit_1(){
        Test.setCurrentPage(Page.SoapWeatherByCity);
        Test.startTest();
        Test.setMock(WebServiceMock.class, new GetWeatherMock());
        SoapWeatherByCityController controller = new SoapWeatherByCityController();
        controller.selectedCountry = '';
        controller.loadCities();
        system.assert(ApexPages.getMessages().size()==1 && controller.cities.size() == 0, 'Something went wrong');
        controller.selectedCountry = 'ITALY';
        controller.loadCities();
        system.assert(controller.cities.size() == 2, 'Number of cities found is not 2 ['+controller.cities+']');
        
        controller.selectedCountry = 'INVALID_COUNTRY';
        controller.loadCities();
        system.assert(controller.cities.size() == 0, 'Number of cities found is not 0 ['+controller.cities+']');
        system.assert(ApexPages.getMessages().size()==2, 'Something went wrong - '+ApexPages.getMessages());
        
        controller.selectedCountry = 'TIMEOUT';
        controller.loadCities();
        system.assert(ApexPages.getMessages().size()==3 &&controller.cities.size() == 0, 'Something went wrong - '+ApexPages.getMessages());
        Test.stopTest();
    }
    
    private static testmethod void test_unit_2(){
        Test.setCurrentPage(Page.SoapWeatherByCity);
        Test.startTest();
        Test.setMock(WebServiceMock.class, new GetWeatherMock());
        SoapWeatherByCityController controller = new SoapWeatherByCityController();
        controller.selectedCountry = 'ITALY';
        controller.selectedCity = '';
        controller.getWeather();
        system.assert(ApexPages.getMessages().size()==1 && controller.wResult == null, 'Something went wrong');
        
        controller.selectedCity = 'CAGLIARI';
        controller.getWeather();
        system.assert(controller.wResult != null, 'No weather returned - '+ApexPages.getMessages());
        
        controller.selectedCity = 'INVALID_COUNTRY';
        controller.getWeather();
        system.assert(controller.wResult == null, 'Found result - '+controller.wResult);
        system.assert(ApexPages.getMessages().size()==2, 'Something went wrong - '+ApexPages.getMessages());
        
        controller.selectedCity = 'TIMEOUT';
        controller.getWeather();
        system.assert(ApexPages.getMessages().size()==3 && controller.wResult == null, 'Something went wrong - '+ApexPages.getMessages());
        Test.stopTest();
    }
}