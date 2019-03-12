Shader "Custom/Toon"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Albedo("Albedo", Color) = (1, 1, 1, 1)
		_RampTex("Ramp Texture", 2D) = "white"{}
		_OutlineColor("Outline Color", Color) = (0, 0, 0, 1)
		_OutlineSize("Outline Size", Range(0.001, 0.1)) = 0.05
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
					//Cuando se declara una normal, se refiere a la normal de los vértices para saber dónde pintar
					float3 normal : NORMAL;
				};

				struct v2f
				{
					float4 pos: SV_POSITION;
					float4 color: COLOR;
				};
				float4 _OutlineColor;
				float _OutlineSize;

				v2f vert(appdata v)
				{
					v2f o;
					o.pos = UnityObjectToClipPos(v.vertex);
					//Regresa 3 dimensiones, ya sea float,fixed o half pero en esta ocasión es float
					//mul: multiplica un matriz por columna del vector  float 3x3 es una matriz tipo gauss-jordan
					float3 norm = normalize(mul((float3x3)UNITY_MATRIX_IT_MV, v.normal));


					return o;
				}

				ENDCG
			};
	}
}
