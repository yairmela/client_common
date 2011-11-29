package playtiLib.config.server
{
	/**
	 * This class configures the deployment mode.
	 * The DEPLOYMENT_MODE is beening used in game config files to set different properties and behaviors. 
	 * The default mode is DEV_MODE.
	 */	
	public class DeploymentConfig{
		
		public static const LOCAL_MODE:int 		= 0;
		public static const DEV_MODE_2:int 		= 4;
		public static const DEV_MODE:int 		= 1;
		public static const STAGING_MODE:int 	= 2;
		public static const PRODUCTION_MODE:int = 3;
		
		public static var DEPLOYMENT_MODE:int 	= DEV_MODE;
	}
}