package org.scribe.exceptions;

/**
 * Default scribe exception. 
 * Represents a problem in the OAuth signing process
 * 
 * @author Pablo Fernandez
 */
public class OAuthException extends RuntimeException
{

  /**
   * Default constructor 
   * @param message message explaining what went wrong
   * @param e original exception
   */
  public OAuthException(String message, Exception e)
  {
    super(message, e);
  }

  /**
   * No-exception constructor. Used when there is no original exception
   *  
   * @param message message explaining what went wrong
   */
  public OAuthException(String message)
  {
    super(message, null);
  }

  private static final long serialVersionUID = 1L;
}
