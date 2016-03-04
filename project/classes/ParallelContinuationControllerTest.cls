@isTest
public class ParallelContinuationControllerTest {
    public static testmethod void unit_test_1() {
        ParallelContinuationController controller = new ParallelContinuationController();

        Continuation conti = (Continuation)controller.startParallelContinuation();
        
        Map<String, HttpRequest> requests = conti.getRequests();
        system.assert(requests.size() == 2);
        system.assert(requests.get(controller.firstLabel) != null);
        system.assert(requests.get(controller.secondLabel) != null);
        
        List<ParallelContinuationController.DesignQuote> dqList = new List<ParallelContinuationController.DesignQuote>();
        dqList.add(new ParallelContinuationController.DesignQuote('Test Name','Test Quote'));
        
        HttpResponse response1 = new HttpResponse();
        response1.setBody(JSON.serialize(dqList));   
        
        HttpResponse response2 = new HttpResponse();
        response2.setBody(JSON.serialize(dqList)); 
        
        Test.setContinuationResponse(controller.firstLabel, response1);
        Test.setContinuationResponse(controller.secondLabel, response2);
        
        // Invoke callback method
        Object result = Test.invokeContinuationMethod(controller, conti);
		
        System.assert(controller.quotes != null && controller.quotes.size() == 2);

    }
}