const float amt = 40.0;

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xy;    
    //float ratio = iResolution.x / iResolution.y;
    float offset = 0.0;
         
    
    float t1 = uv.x + uv.y;
    float band = .5;
    
    if(t1 > 0. && t1 < 1.*band)
    {
        offset = 1.*amt;
    }
    else if(t1 >band && t1 < 2.*band)
    {
    	offset = 1. * amt;
    }
    else if(t1 > 2.*band && t1 < 3.*band)
    {
    	offset = -1.*amt;
    }
    else if(t1 > 3.*band)
    {
    	offset = -1. * amt;
    }
    

	vec4 col0 = texture(iChannel0, uv + vec2(offset, - offset)/*, -10.*/);

    
    fragColor = col0;
      
}