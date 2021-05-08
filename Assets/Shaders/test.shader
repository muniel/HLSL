Shader "Custom/test"
{
    SubShader
    {
        CGINCLUDE   // ここからENDCGまでにメインの処理や変数を置く

        // （２）頂点シェーダーで利用する情報を入れるところ
        struct vsIn
        {
            float4 position : POSITION;
            float4 Normal : NORMAL;
            // half4 Tan : TANGENT;
            // float4 Col : COLOR0;
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

        // （５）ピクセルシェーダーの処理を作るところ
        fixed4 frag(fsIn input) : COLOR
        {
            // return float4(1.0, 0.5, 0.0, 1.0);
			return input.Normal;
            // return input.Tan;
            // return input.Col;
        }
        ENDCG

        Pass    // 実際に実行される関数の順番
        {
            CGPROGRAM
            // （６）頂点シェーダーとピクセルシェーダーをまとめるところ
           #pragma vertex vert
           #pragma fragment frag
           #include "UnityCG.cginc"
            ENDCG
        }
    }
}