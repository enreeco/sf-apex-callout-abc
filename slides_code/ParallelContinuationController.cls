public class ParallelContinuationController{
    private String firstLabel;
    private String secondLabel;
    
    public List<DesignQuote> quotes{get;set;}
    
    //class to parse JSON
    public class DesignQuote{
        public String title{get;set;}
        public String content{get;set;}
    }
    
    public ParallelContinuationController(){
        this.quotes = new List<DesignQuote>();
    }
    
    public Object startParallelContinuation(){
        Continuation cnt = new Continuation(60);
        cnt.continuationMethod = 'processParallelContinuation';
        
        HttpRequest req1 = new HttpRequest();
        req1.setEndpoint('http://quotesondesign.com/wp-json/posts?filter[orderby]=rand');
        req1.setMethod('GET');
        req1.setTimeout(30000);
        this.firstLabel = cnt.addHttpRequest(req1);    
        
        HttpRequest req2 = new HttpRequest();
        req2.setEndpoint('http://quotesondesign.com/wp-json/posts?filter[orderby]=rand');
        req2.setMethod('GET');
        req2.setTimeout(30000);
        this.secondLabel = cnt.addHttpRequest(req2);  
        
        return cnt;
    }

    public void processParallelContinuation(){
        HttpResponse response1 = Continuation.getResponse(this.firstLabel);
        this.quotes.addAll((List<DesignQuote>) JSON.deserialize(response1.getBody(), List<DesignQuote>.class));

        HttpResponse response2 = Continuation.getResponse(this.secondLabel);
        this.quotes.addAll((List<DesignQuote>) JSON.deserialize(response2.getBody(), List<DesignQuote>.class));

    }
}