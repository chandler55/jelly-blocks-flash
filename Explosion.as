package
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	
	public class Explosion
	{
		/*
			EXPLOSION PARAMETERS
		*/
		//-- START VALUES
		private const EXPLOSION_RADIUS: int = 30;
		private const EXPLOSION_MAX_VELOCITY: Number = 2;
		private const EXPLOSION_MAX_HEAT: int = -1; // causes particles to move up
		
		private const PARTICLE_CHAOTIC_MOVE: Number = 0;
		private const PARTICLE_DAMP_MOVE: Number = .95;
		private const PARTICLE_DAMP_ENERGIE: Number = .999;
		
		//-- AMOUNT
		private const P_COUNT: int = 200;
		private const PCOUNT_EACH_FRAME: int = 200;

		private var t_particles: Array;
		private var c_particles: Array;
		
		private var energie: Number;
		//private var transform: ColorTransform;
		private var color:int = 0;
		private var counter:int = 0;
		private var dead:Boolean = false;
		public function Explosion( x: Number, y: Number, fcolor:int )
		{
			init( x, y, fcolor );
		}
		public function getColor():int {
			return color;
		}
		public function isDead():Boolean {
			return dead;
		}
		
		private function init( x: Number, y: Number, fcolor:int ): void
		{
			color = fcolor;
			t_particles = new Array();
			c_particles = new Array();
			
			energie = 1;
			
			var a: Number;
			var s: Number;
			var l: Number;
			
			var particle: Particle;
			
			for( var i: int = 0 ; i < P_COUNT ; i++ )
			{
				a = Math.random() * Math.PI * 2;
				s = Math.random() * EXPLOSION_MAX_VELOCITY + 1;
				l = Math.random() * EXPLOSION_RADIUS;
				
				particle = new Particle
				(
					//-- screen position
					x + Math.sin( a ) * l,
					y + Math.cos( a ) * l,
					
					//-- velocity (x,y)
					Math.sin( a ) * s,
					Math.cos( a ) * s - Math.random() * EXPLOSION_MAX_HEAT,
					
					//-- start energie, damp energie
					1,
					PARTICLE_DAMP_ENERGIE
				);
				
				t_particles.push( particle );
			}
		}
		
		public function render( buffer: BitmapData ): void
		{
			counter++;
			if (counter > 50)
				dead = true;
			if( t_particles.length >= PCOUNT_EACH_FRAME )
			{
				c_particles = c_particles.concat( t_particles.splice( -PCOUNT_EACH_FRAME ) );
			}
			else if( t_particles.length > 0 )
			{
				c_particles = t_particles.splice();
			}
			
			var particle: Particle;
			var sx: Number;
			var sy: Number;
			var vx: Number;
			var vy: Number;
			
			var e: int;
			
			var i: int = c_particles.length;

			while( --i > -1 )
			{
				particle = c_particles[i];
				
				sx = particle.sx;
				sy = particle.sy;
				vx = particle.vx;
				vy = particle.vy;
				
				//vx += Math.random() / ( .5 / PARTICLE_CHAOTIC_MOVE ) - PARTICLE_CHAOTIC_MOVE;
				//vy += Math.random() / ( .5 / PARTICLE_CHAOTIC_MOVE ) - PARTICLE_CHAOTIC_MOVE;
				
				if( particle.energie < .1 )
				{
					c_particles.splice( i, 1 );
				}
				
				particle.energie *= particle.energieDamp;
				
				buffer.setPixel32( sx, sy, int(   0xff ) * 16843009 );
				//buffer.setPixel32( sx+1, sy, int( particle.energie * 0xff ) * 16843009 );
				//buffer.setPixel32( sx, sy+1, int( particle.energie * 0xff ) * 16843009 );
				//buffer.setPixel32( sx+1, sy+1, int( particle.energie * 0xff ) * 16843009 );

				
				sx += vx;
				sy += vy;
				
				vx *= PARTICLE_DAMP_MOVE;
				vy *= PARTICLE_DAMP_MOVE;
				
				particle.sx = sx;
				particle.sy = sy;
				particle.vx = vx;
				particle.vy = vy;
			}
		}
	}
}