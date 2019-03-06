Shader "Custom/Toon"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Albedo("Albedo", Color) = (1, 1, 1, 1)
		_RampTex("Ramp Texture", 2D) = "white"{}
	}
		SubShader
		{
			CGPROGRAM
			#pragma surface surf ToonRamp
			float4 _Albedo;
			sampler2D _MainTex;
			sampler2D _RampTex;
		
			float4 LightingToonRamp(SurfaceOutput s, fixed2 lightDir, fixed atten)
			{
				half diff = dot(s.Normal, lightDir); // -1 hasta 1
				float uv = (diff * 0.5) + 0.5; // la coordenada donde voy a ver el uv
				float3 ramp = tex2D(_RampTex, uv).rgb;
				float4 c;
				c.rgb = s.Albedo * _LightColor0.rgb * ramp;
				c.a = s.Alpha;
				return c;
			}

			struct Input
			{
				float2 uv_MainTex;
			};

			void surf(Input IN, inout SurfaceOutput o)
			{
				o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb * _Albedo.rgb;
			}
		ENDCG

			Pass
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				#include "UnityCG.cginc"

				struct appdata
				{
					float4 vertex : POSITION;
					float2 uv : TEXCORD0;
					//Cuando se declara una noramla, se refiere a la normal de los vértices para saber dónde pintar
					float3 normal : NORMAL;
				};
				ENDCG
			};
	}
}
