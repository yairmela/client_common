package playtiLib.utils.social.mm {
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	
	[Event( name="complete", type="flash.events.Event" )]
	
	public class MailruCall	{
		
		static private var call_back     : Object = {};
		static private var flash_id       : String;
		static private var app_private_key : String;
		static private var dispatcher    : EventDispatcher = new  EventDispatcher();
		static private var is_inited      : Boolean = false;
		
		static public function init ( DOMFlashId : String, privateKey : String ) : void {
			
			if ( is_inited ) { throw Error ( 'MailruCall already initialized' ); return; }
			flash_id = DOMFlashId;
			app_private_key = privateKey;
			ExternalInterface.addCallback( 'mailruReceive', receiver );
			exec ( 'mailru.init', onApiLoaded, privateKey, flash_id );
			is_inited = true;
		}
		
			/** If callback is not specified, exec() Try to return a value **/	
		static public function exec ( method : String, callback : Function = null, ...args ) : * {
			
			trace('method    ' + method);
			trace('exec    ' + args.toString());
			var cbid : int;
			if ( callback != null ) {
				cbid = Math.round ( Math.random() * int.MAX_VALUE );
				call_back[cbid] = callback;
			}
			var object_name:String = ( method.match(/(.*)\.[^.]+$/)||[0,'window'] )[1];
			
			var str:String  = 			'(function(args, cbid){ ' +  
				'if(typeof ' + method + ' != "function"){ alert(1);' +
				'	if(cbid) { document.getElementById("'+ flash_id+ '").mailruReceive(cbid, ' + method + '); }' +
				'	else { return '+ method+ '; }' +
				'}' +  			
				'if(cbid) {' + 
				'	args.unshift(function(value){ ' + 
				'		document.getElementById("'+ flash_id+ '").mailruReceive(cbid, value) ' +
				'	}); ' + 
				'};' + 
				'return '+ method+ '.apply('+ object_name+ ', args) ' + 
				'})';  
			
			return ExternalInterface.call('' + str, args, cbid);
		}
		
		static private function receiver ( cbid : Number, data : Object ) : void {
			
			if ( call_back[cbid] ) {
				var cb : Function = call_back[cbid];
				delete call_back[cbid];
				cb.call ( null, data );
			}
		}
		
		static private function eventReceiver ( name : String, data : Object ) : void {
			
			dispatchEvent ( new MailruCallEvent ( name, data ) );
		}
			
		static private function onApiLoaded ( ...args ) : void {
			
			ExternalInterface.addCallback ( 'mailruEvent', eventReceiver );
			dispatchEvent ( new Event ( Event.COMPLETE ) );
		}
		
		/************************* EventDispatcher IMPLEMENTATION ****************************/
		
		static public function addEventListener ( type : String, listener : Function, priority : int = 0, useWeakReference : Boolean = false ):void {
			
	   		dispatcher.addEventListener ( type, listener, false, priority, useWeakReference );
		}
		
		static public function removeEventListener ( type : String, listener : Function ) : void {
			
			dispatcher.removeEventListener ( type, listener );
		}
		
		static public function hasEventListener ( type : String ) : Boolean {
			
			return dispatcher.hasEventListener ( type );
		}
		
		static public function dispatchEvent ( event : Event ) : void {
			
			dispatcher.dispatchEvent ( event );
		}
		
	}
}