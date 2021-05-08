Shader "Custom/test_toon"
{
    // float4x4 gWVP   : UNITY_MATRIX_MVP;
    // float4x4 UNITY_MATRIX_IT_MV   : UNITY_MATRIX_IT_MV;
    // float4x4 unity_ObjectToWorld   : unity_ObjectToWorld;
    // float4x4 gVP   : UNITY_MATRIX_VP;

    Properties
    {
        gBaseColor ("Base Color", Color) = (1.0, 0.0, 0.0, 0.0)
        gOutlineColor ("Outline Color", Color) = (0.0, 0.0, 0.0, 0.0)
        gOutlineWidth ("Outline Width", Range(0.0, 1.0) ) = 0.1

    }

    SubShader
    {
        CGINCLUDE   // ここからENDCGまでにメインの処理や変数を置く



        // （２）頂点シェーダーで利用する情報を入れるところ
        struct vsIn
        {
            float3 position : POSITION;
            float4 Normal : NORMAL;
            // half4 Tan : TANGENT;
            // float4 Col : COLOR0;
        };

        struct vert_Outline_input
        {
            float3 position : POSITION;
            float4 Normal : NORMAL;
        };

        // （３）ピクセルシェーダーで利用する情報を入れるところ
        struct fsIn
        {
            float4 position : SV_POSITION;
            float4 Normal : NORMAL;
            // half4 Tan : TANGENT;
            // float4 Col : COLOR0;
        };

        // （４）頂点シェーダーの処理を作るところ　基本Posの行はそのままで、他のチャンネル情報を加味する場合は後述する
        fsIn vert(vsIn input)
        {
            fsIn o;
			o.position = UnityObjectToClipPos(input.position);
            o.Normal = input.Normal;
            // o.Tan = input.Tan;
            // o.Col = input.Col;
            return o;
        }

        fsIn vert_Outline(vert_Outline_input input)
        {
            fsIn o;
            float3 worldPosition = mul(float4(input.position, 1), unity_ObjectToWorld).xyz;

            float3 worldNormal = mul(input.Normal, UNITY_MATRIX_IT_MV).xyz;
            worldNormal *= gOutlineWidth;
            worldPosition += worldNormal;

            o.position = mul(float4(worldPosition, 1), UNITY_MATRIX_VP);
            return o
        }


        // （５）ピクセルシェーダーの処理を作るところ
        float4 frag(fsIn input) : SV_Target
        {
            // return float4(1.0, 0.5, 0.0, 1.0);
			return input.Normal;
            // return input.Tan;
            // return input.Col;
        }

        float4 frag_Outline(fsIn input) : SV_Target
        {
            return float4(gOutlineColor, 1.0);
        }
        ENDCG

        Pass    // 実際に実行される関数の順番
        {
            CGPROGRAM
            // （６）頂点シェーダーとピクセルシェーダーをまとめるところ
           #pragma vertex vert
           #pragma fragment frag
           #pragma vertex vert_Outline
           #pragma fragment frag_Outline
           #include "UnityCG.cginc"
            ENDCG
        }
    }
}