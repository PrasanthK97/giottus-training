package com.training.config;

import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.session.Session;
import org.springframework.session.SessionRepository;
import org.springframework.session.data.redis.config.annotation.web.http.EnableRedisHttpSession;
import org.springframework.session.web.context.AbstractHttpSessionApplicationInitializer;
import org.springframework.session.web.http.CookieHttpSessionIdResolver;
import org.springframework.session.web.http.CookieSerializer;
import org.springframework.session.web.http.DefaultCookieSerializer;
import org.springframework.session.web.http.SessionRepositoryFilter;

@Configuration
@EnableRedisHttpSession
public class SessionConfig extends AbstractHttpSessionApplicationInitializer {
	@Bean
	public <S extends Session> SessionRepositoryFilter<? extends Session> springSessionRepositoryFilter(SessionRepository<S> sessionRepository) {
	    SessionRepositoryFilter<S> sessionRepositoryFilter = new SessionRepositoryFilter<S>(sessionRepository);
	    CookieHttpSessionIdResolver cookieResolver = new CookieHttpSessionIdResolver();
	    cookieResolver.setCookieSerializer(this.cookieSerializer());
	    sessionRepositoryFilter.setHttpSessionIdResolver(cookieResolver);
	    return sessionRepositoryFilter;
	}

	private CookieSerializer cookieSerializer() {
	    DefaultCookieSerializer serializer = new DefaultCookieSerializer();
	    serializer.setCookiePath("/");
	    serializer.setUseHttpOnlyCookie(true);
	    serializer.setUseSecureCookie(false);
	    serializer.setCookieMaxAge(86400);
	    return serializer;
	}

	@Bean
	public HttpSessionListener httpSessionListener() {
		return new HttpSessionListener() {
			@Override
			//this method will be called when session created
			public void sessionCreated(HttpSessionEvent event) {
				HttpSession session = event.getSession();
				if(session != null) {
					System.out.println("Session created with session id: " + session.getId());
				}
			}

			@Override
			//this method will be automatically called when session is destroyed
			public void sessionDestroyed(HttpSessionEvent event) {
				HttpSession session = event.getSession();
				if(session == null) {
					return;
				}

				System.out.println("Session destroyed, session id: " + session.getId());
				System.out.println("User id: " + session.getAttribute("user_id"));
			}
		};
	}
}
