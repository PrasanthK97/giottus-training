package com.training.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.training.util.RestUtil;

import com.training.TrainingUiApplication;

@Configuration
@RestController
public class TrainingController {
    @Autowired
    private RestUtil restUtil;
    

    private static final Logger LOGGER = LogManager.getLogger(TrainingController.class);

    @GetMapping(value="/test")
    public String test() {
        return "Works!";
    }

    @GetMapping(value="/registration")
    public ModelAndView registration(){
        return new ModelAndView("registration");
    }


    @GetMapping(value= "/countPage")
    public ModelAndView showCount(HttpSession session){
        
        return new ModelAndView("subscription_count");
    }

    @PostMapping(value="/doregistration")
    public String doRegistration(HttpSession session, String student_name, String password) throws JsonProcessingException {
        JSONObject response = new JSONObject();
        response.put("status",JSONObject.NULL);
        response.put("message", JSONObject.NULL);
        
        try{          
                Map<String,Object>params=new HashMap<String,Object>();
                params.put("student_name", student_name);
                params.put("password", password);
                String details =restUtil.post("http://localhost:8000/student/register/",params);
                //response.put("message", details);
                return details.toString();
        }
        catch( Exception ex){
            response.put("status", "failure");
            response.put("error", ex);
            return response.toString();
        } 

    }

    @GetMapping(value="/login")
    public ModelAndView login() {
        return new ModelAndView("login");
    }

    @PostMapping(value="/dologin")
    public String doLogin(HttpSession session, String userName, String password) throws JsonProcessingException {
    JSONObject response = new JSONObject();
        
        HashMap<String, Object> params = new HashMap<>();
        params.put("student_name", userName);
        params.put("password", password);
        String details = restUtil.post("http://localhost:8000/student/verify",params);
        JSONObject detailsObject = new JSONObject(details);
        if(detailsObject.get("status").equals("success")){
            Integer id1 = (int) detailsObject.get("student_id");
            session.setAttribute("user_id", id1);
            //session.setAttribute("user_id", 1); 
            response.put("status", "success");
            response.put("message", JSONObject.NULL);
            response.put("data", "yes");
            Integer id = (int) session.getAttribute("user_id"); 
            response.put("id", id);
        }
        else {
            response.put("status", "failure");
            response.put("message", "Invalid login credentials!");
            response.put("data", details);
        }

        return response.toString();
    }


    @PostMapping(value="/subscribe/subject")
    public String subscribeSubject(HttpSession session, Integer subject_id, Integer student_id) throws JsonProcessingException {
        
        try{
            Integer userId = (Integer) session.getAttribute("user_id");
            if(userId!=null){
                Map<String,Object>params=new HashMap<String,Object>();
                params.put("student_id", userId);
                params.put("subject_id", subject_id);
                String details =restUtil.post("http://localhost:8000/student/subscribe/",params);
                return details;
            }

            JSONObject response=new JSONObject();
            response.put("status","failure");
            response.put("message","you need to be logged in to view deatails");
            response.put("data",JSONObject.NULL);

            return response.toString();
        }catch(Exception ex){
            
            JSONObject response=new JSONObject();
            response.put("status", "failure");
            response.put("message", "unable to get the details");
            response.put("data", subject_id );
            response.put("error_data", ex );

            return response.toString();
        }
    }

    @PostMapping(value= "/student/subject/delete")
    public String deleteStudentSubject(HttpSession session, Integer student_id, Integer subject_id) throws JsonProcessingException {
    
        
            Integer userId = (Integer) session.getAttribute("user_id");
            //if(userId != null){
                Map<String, Object> params = new HashMap<String, Object>();
                params.put("student_id", userId);
                params.put("subject_id", subject_id);
                String details = restUtil.post("http://localhost:8000/delete/subject",params);
                return details.toString();
           // }
            
        // catch(Exception e){

        //     JSONObject response=new JSONObject();
        //     response.put("status", "failure");
        //     response.put("message", "unable to get the details");
        //     response.put("data",JSONObject.NULL );

        //     return response.toString();
        // }
    }

    @GetMapping(value="/home")
    //public ModelAndView home(HttpSession session, ModelAndView mv) {
    public ModelAndView home(HttpSession session, ModelAndView mv) {
        Integer userId = (Integer) session.getAttribute("user_id");
        if(userId != null) {
            return new ModelAndView("home");
        }

        return new ModelAndView("redirect:/login");
    }

    @GetMapping(value="/subjects_count")
    public ModelAndView subjectsCount(HttpSession session, ModelAndView mv) {
            return new ModelAndView("subscription_count");
    }



    public  static String subjectCountDetails = null;
    @PostMapping(value="/subject/count")
    public String getSubjectCount(HttpSession session, String subject_id, String order) throws JsonProcessingException{
        
        try{
            Map<String, Object>params = new HashMap<String, Object>();
            session.setAttribute("subject_id", subject_id);
            params.put("subject_id", subject_id);
            params.put("order", order);
            String details = restUtil.post("http://localhost:8000/subject/count/", params);
            subjectCountDetails = details;
            return details.toString();
        }
        catch(Exception ex){
            LOGGER.error("e",ex);
            JSONObject response=new JSONObject();
            response.put("status", "failure");
            response.put("message", "unable to get the details");
            response.put("data", "subject_id" );
            response.put("error_data", "ex" );
        return response.toString();
        }
    }
    public static String getSubjectCountMethod(){
        return subjectCountDetails;
    }

    @GetMapping(value = "/test2")
    public String test2(){
        return "test2";
    }

    @GetMapping(value = "/subjects/selected")
    public String allSelectedSubjects(HttpSession session){
        try{
            Integer userId =(Integer) session.getAttribute("user_id");
            if(userId!=null){
                HashMap<String,Object>params=new HashMap<String,Object>();
                String details =restUtil.get("http://localhost:8000/student/subjects/"+ userId, params);
                return details.toString();
            }

            JSONObject response=new JSONObject();
            response.put("status","failure");
            response.put("message","you need to be logged in to view deatails");
            response.put("data",JSONObject.NULL);

            return response.toString();
        }catch(Exception ex){
            
            JSONObject response=new JSONObject();
            response.put("status", "failure");
            response.put("message", "unable to get the details");
            response.put("data",JSONObject.NULL );

            return response.toString();
        }
    }

      @GetMapping(value = "/student/subjects/{id}")
    public String allSelectedSubjects2(HttpSession session, @PathVariable String id){
        try{
            Integer userId =(Integer) session.getAttribute("user_id");
            System.out.println("This is the id----------------->"+ id);
            // if(userId!=null){
                System.out.println("This is the id after entering----------------->"+ id);
                HashMap<String,Object>params=new HashMap<String,Object>();
                String details =restUtil.get("http://localhost:8000/student/subjects/"+ id, params);
                System.out.println("This is the id response-------->"+ details.toString());
                return details.toString();
                
            // }

            // JSONObject response=new JSONObject();
            // response.put("status","failure");
            // response.put("message","you need to be logged in to view deatails");
            // response.put("data",JSONObject.NULL);

            // return response.toString();
        }catch(Exception ex){
            
            JSONObject response=new JSONObject();
            response.put("status", "failure");
            response.put("message", "unable to get the details");
            response.put("data",JSONObject.NULL );

            return response.toString();
        }
    }


    @GetMapping(value = "/subjects")
    public String allsubjects(HttpSession session) throws JsonProcessingException{
        try{
            Integer userId =(Integer) session.getAttribute("user_id");
            if(userId!=null){
                 return TrainingUiApplication.getSubjects();

            }

            JSONObject response=new JSONObject();
            response.put("status","failure");
            response.put("message","you need to be logged in to view deatails");
            response.put("data",JSONObject.NULL);

            return response.toString();
        }catch(Exception ex){
            
            JSONObject response=new JSONObject();
            response.put("status", "failure");
            response.put("message", "unable to get the details");
            response.put("data",JSONObject.NULL );

            return response.toString();
        }
    }
 
    /* 

    @GetMapping(value = "/subjects")
    public String allsubjects(HtttpSession session) {
        try{
            Integer userId = (Integer) session.getAttribute("user_id");
            if(userId != null){
                    Map<String,Object>params = new HashMap<String,Object>();
                    String details =restUtil.get("http://localhost:8000/subject", params);
                    return details;
            }
            JSONObject response = new JSONObject();
            response.put("status", "failure");
            response.put("message", "You need to be logged in to view details!");
            response.put("data", JSONObject.NULL);
        

            return response.toString();
        } catch(Exception ex) {
            //LOGGER.error("details", ex);
            JSONObject response = new JSONObject();
            response.put("status", "failure");
            response.put("message", "Unable to get the details!");
            response.put("data", JSONObject.NULL);

            return response.toString();
        }
    }
*/

    @GetMapping(value= "/admin")
    public ModelAndView admin(HttpSession session){
        
        return new ModelAndView("admin");
    }

    @GetMapping(value="/details")
    public String details(HttpSession session) {
        try {
            Object userId = session.getAttribute("user_id");
            if(userId != null) {
                Map<String, Object> params = new HashMap<String, Object>();
                String details = restUtil.get("http://localhost:8000/student/" + userId, params);
                return details;
            }

            JSONObject response = new JSONObject();
            response.put("status", "failure");
            response.put("message", "You need to be logged in to view details!");
            response.put("data", JSONObject.NULL);

            return response.toString();
        } catch(Exception ex) {
            LOGGER.error("details", ex);
            JSONObject response = new JSONObject();
            response.put("status", "failure");
            response.put("message", "Unable to get the details!");
            response.put("data", JSONObject.NULL);

            return response.toString();
        }
    }

  
}
