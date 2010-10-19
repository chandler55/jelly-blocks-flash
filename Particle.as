package
{
	public class Particle
	{
		public var sx: Number;
		public var sy: Number;

		public var vx: Number;
		public var vy: Number;
		
		public var energie: Number;
		public var energieDamp: Number;
		
		public function Particle( sx: Number, sy: Number, vx: Number, vy: Number, energie: Number, energieDamp: Number )
		{
			this.sx = sx;
			this.sy = sy;
			
			this.vx = vx;
			this.vy = vy;

			this.energie = energie;			
			this.energieDamp = energieDamp;
		}

	}
}