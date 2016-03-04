@isTest
global class GetWeatherMock implements WebServiceMock {
  public class GetWeatherMockException extends Exception{}
    
    global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
               
    if(requestName == 'GetCitiesByCountry'){
            GetWeather.GetCitiesByCountry_element request_x = (GetWeather.GetCitiesByCountry_element)request;
            String val = '';
            if(request_x.CountryName == 'ITALY'){
                val = '<NewDataSet><Table><Country>Italy</Country><City>Rome</City></Table>'
                        +'<Table><Country>Italy</Country><City>Cagliari</City></Table></NewDataSet>';
            }else if(request_x.CountryName == 'TIMEOUT'){
                throw new GetWeatherMockException('TIMEOUT EXCEPTION');
            }else{
                val = '<NewDataSet></NewDataSet>';
            }
            GetWeather.GetCitiesByCountryResponse_element response_x = new GetWeather.GetCitiesByCountryResponse_element();
            response_x.GetCitiesByCountryResult = val;
          response.put('response_x', response_x);     
            
        }else if(requestName == 'GetWeather'){
            
            GetWeather.GetWeather_element request_x = (GetWeather.GetWeather_element)request;
            String val = '';
            
            if(request_x.CityName == 'CAGLIARI'){
                
              val = '<CurrentWeather>'
                          +'<Location>Cagliari / Elmas, Italy (LIEE) 39-15N 009-04E 5M</Location>'
                          +'<Time>Feb 08, 2016 - 11:50 AM EST / 2016.02.08 1650 UTC</Time>'
                          +'<Wind> from the WNW (290 degrees) at 12 MPH (10 KT) (direction variable):0</Wind>'
                          +'<Visibility> greater than 7 mile(s):0</Visibility>'
                          +'<SkyConditions> mostly clear</SkyConditions>'
                          +'<Temperature> 57 F (14 C)</Temperature>'
                          +'<DewPoint> 46 F (8 C)</DewPoint>'
                          +'<RelativeHumidity> 67%</RelativeHumidity>'
                          +'<Pressure> 30.21 in. Hg (1023 hPa)</Pressure>'
                          +'<Status>Success</Status>'
                        +'</CurrentWeather>';
            }else if(request_x.CityName == 'TIMEOUT'){
                throw new GetWeatherMockException('TIMEOUT EXCEPTION');
            }else{
                val = 'Data not found';
            }
            GetWeather.GetWeatherResponse_element response_x = new GetWeather.GetWeatherResponse_element();
            response_x.GetWeatherResult = val;
          response.put('response_x', response_x);     
        }
   }
}