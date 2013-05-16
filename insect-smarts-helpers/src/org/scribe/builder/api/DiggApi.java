package org.scribe.builder.api;

import org.scribe.model.*;

public class DiggApi extends DefaultApi10a 
{

  private static final String AUTHORIZATION_URL = "http://digg.com/oauth/authorize?oauth_token=%s";
  private static final String BASE_URL = "http://services.digg.com/oauth/";

  @Override
  public String getRequestTokenEndpoint() 
  {
    return BASE_URL + "request_token";
  }

  @Override
  public String getAccessTokenEndpoint() 
  {
    return BASE_URL + "access_token";
  }

  @Override
  public String getAuthorizationUrl(Token requestToken) 
  {
    return String.format(AUTHORIZATION_URL, requestToken.getToken());
  }

}
