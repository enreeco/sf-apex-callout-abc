@isTest
public class RestCountriesClientMock implements HttpCalloutMock {
    private Integer mode = 0;
    //mode = 0 > 2 results
    //mode = -1 > invalid JSON
    public RestCountriesClientMock(Integer mode){
        this.mode = mode;
    }
	public HTTPResponse respond(HTTPRequest req) {
        HTTPResponse resp = new HTTPResponse();
        resp.setStatusCode(200);
        if(mode < 0){
            resp.setBody('{THIS_IS_AN_INVALID_JSON');
            return resp;
        }
		List<SoapWeatherByCityController.Country> countries = new List<SoapWeatherByCityController.Country>();
		SoapWeatherByCityController.Country tmp = new SoapWeatherByCityController.Country();
        tmp.name = 'Test';
        tmp.capital = 'Test Capital';
        tmp.translations = new Map<String,String>();
        tmp.languages = new List<String>{'it'};
        countries.add(tmp);
        tmp = new SoapWeatherByCityController.Country();
        tmp.name = 'Test2';
        tmp.capital = 'Test2 Capital';
        tmp.translations = new Map<String,String>();
        tmp.languages = new List<String>{'en'};        
        countries.add(tmp);
        resp.setBody(JSON.serialize(countries));
        return resp;
    }
}