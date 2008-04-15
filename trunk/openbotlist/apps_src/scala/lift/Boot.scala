/**
 * Boot.scala
 */
package bootstrap.liftweb

import net.liftweb.util.{Helpers, Can, Full, Empty, Failure, Log}
import net.liftweb.http._
import Helpers._
import javax.servlet.http.{HttpServlet, HttpServletRequest , HttpServletResponse, HttpSession}

import org.spirit.lift.agents._
 
/**
  * A class that's instantiated early and run.  It allows the application
  * to modify lift's environment
  */
class Boot {
  def boot {
	LiftRules.addToPackages("org.spirit.lift.agents")
	val dispatcher: LiftRules.DispatchPf = {         
	  // In our pseudo REST architecture, 'types' is associated with
	  // the payload dumps and their types.  
	  // In layman terms, a type is a article link and attributes.
	  case RequestMatcher(r, ParsePath("lift" :: "pipes" :: "types" :: c :: _, _,_),_, _) => 
		invokeAgents(r, c)
    }
	LiftRules.addDispatchBefore(dispatcher)
  }
  private def invokeAgents(request: RequestState, methodName: String)(req: RequestState): Can[ResponseIt] =
	createInvoker(methodName, new RemoteAgents(request)).flatMap(_() match {
	  case Full(ret: ResponseIt) => Full(ret)
      case _ => Empty
	})

} // End of Class 

