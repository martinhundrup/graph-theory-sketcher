Shader "Shader Graphs/NewPixelOutline"
{
    Properties
    {
        [NoScaleOffset]_MainTex("Main Texture", 2D) = "white" {}
        _OutlineThickness("Outline Thickness", Float) = 1
        _OutlineColor("Outline Color", Color) = (1, 1, 1, 1)
        [Toggle]CORNERS("Sample Corners", Float) = 0
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}

        _StencilComp ("Stencil Comparison", Float) = 8
        _Stencil ("Stencil ID", Float) = 0
        _StencilOp ("Stencil Operation", Float) = 0
        _StencilWriteMask ("Stencil Write Mask", Float) = 255
        _StencilReadMask ("Stencil Read Mask", Float) = 255
        _ColorMask ("Color Mask", Float) = 15
    }
    SubShader
    {
        ColorMask [_ColorMask]

        Stencil
        {
            Ref [_Stencil]
            Comp [_StencilComp]
            Pass [_StencilOp]
            ReadMask 255
            WriteMask 255
        }
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "UniversalMaterialType" = "Lit"
            "Queue"="Transparent"
            // DisableBatching: <None>
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalSpriteLitSubTarget"
        }
        Pass
        {
            Name "Sprite Lit"
            Tags
            {
                "LightMode" = "Universal2D"
            }
        
        // Render State
        Cull Off
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma exclude_renderers d3d11_9x
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile _ USE_SHAPE_LIGHT_TYPE_0
        #pragma multi_compile _ USE_SHAPE_LIGHT_TYPE_1
        #pragma multi_compile _ USE_SHAPE_LIGHT_TYPE_2
        #pragma multi_compile _ USE_SHAPE_LIGHT_TYPE_3
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma shader_feature_local _ CORNERS_ON
        
        #if defined(CORNERS_ON)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif
        
        
        // Defines
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_COLOR
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_POSITION_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_COLOR
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_SCREENPOSITION
        #endif
        
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SPRITELIT
        #define ALPHA_CLIP_THRESHOLD 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/LightingUtility.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 color : COLOR;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 color;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 screenPosition;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv0;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord0 : INTERP0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 color : INTERP1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 screenPosition : INTERP2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionWS : INTERP3;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.color.xyzw = input.color;
            output.screenPosition.xyzw = input.screenPosition;
            output.positionWS.xyz = input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.color = input.color.xyzw;
            output.screenPosition = input.screenPosition.xyzw;
            output.positionWS = input.positionWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _MainTex_TexelSize;
        float _OutlineThickness;
        float4 _OutlineColor;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Comparison_GreaterOrEqual_float(float A, float B, out float Out)
        {
            Out = A >= B ? 1 : 0;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
        Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        struct Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float
        {
        half4 uv0;
        };
        
        void SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(UnityTexture2D _Texture, float _OutlineThickness, float2 _Direction, Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float IN, out float Alpha_2)
        {
        UnityTexture2D _Property_abbd8b98b7ae46a7a589002ac361020f_Out_0_Texture2D = _Texture;
        float4 _UV_28706884e92b49018cd93fc942406a75_Out_0_Vector4 = IN.uv0;
        UnityTexture2D _Property_75130dae886e4ba88386713011b81ac6_Out_0_Texture2D = _Texture;
        float _TextureSize_387b805f38414b1baee12c937d38b1c0_Width_0_Float = _Property_75130dae886e4ba88386713011b81ac6_Out_0_Texture2D.texelSize.z;
        float _TextureSize_387b805f38414b1baee12c937d38b1c0_Height_2_Float = _Property_75130dae886e4ba88386713011b81ac6_Out_0_Texture2D.texelSize.w;
        float _TextureSize_387b805f38414b1baee12c937d38b1c0_TexelWidth_3_Float = _Property_75130dae886e4ba88386713011b81ac6_Out_0_Texture2D.texelSize.x;
        float _TextureSize_387b805f38414b1baee12c937d38b1c0_TexelHeight_4_Float = _Property_75130dae886e4ba88386713011b81ac6_Out_0_Texture2D.texelSize.y;
        float2 _Vector2_6eddb764a241497e9427406cae4687a4_Out_0_Vector2 = float2(_TextureSize_387b805f38414b1baee12c937d38b1c0_TexelWidth_3_Float, _TextureSize_387b805f38414b1baee12c937d38b1c0_TexelHeight_4_Float);
        float _Property_2fe213d5a4df4752815fa1d9c39276b5_Out_0_Float = _OutlineThickness;
        float2 _Multiply_873730e798d1451e893758a79882ee2b_Out_2_Vector2;
        Unity_Multiply_float2_float2(_Vector2_6eddb764a241497e9427406cae4687a4_Out_0_Vector2, (_Property_2fe213d5a4df4752815fa1d9c39276b5_Out_0_Float.xx), _Multiply_873730e798d1451e893758a79882ee2b_Out_2_Vector2);
        float2 _Property_e60d2a2ec0b54194af044138b75995ba_Out_0_Vector2 = _Direction;
        float2 _Multiply_e4de5667f8654b52a08221801a0ada79_Out_2_Vector2;
        Unity_Multiply_float2_float2(_Multiply_873730e798d1451e893758a79882ee2b_Out_2_Vector2, _Property_e60d2a2ec0b54194af044138b75995ba_Out_0_Vector2, _Multiply_e4de5667f8654b52a08221801a0ada79_Out_2_Vector2);
        float2 _Add_ddce0338db784adda4e04a8f39383f1a_Out_2_Vector2;
        Unity_Add_float2((_UV_28706884e92b49018cd93fc942406a75_Out_0_Vector4.xy), _Multiply_e4de5667f8654b52a08221801a0ada79_Out_2_Vector2, _Add_ddce0338db784adda4e04a8f39383f1a_Out_2_Vector2);
        float4 _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_abbd8b98b7ae46a7a589002ac361020f_Out_0_Texture2D.tex, _Property_abbd8b98b7ae46a7a589002ac361020f_Out_0_Texture2D.samplerstate, _Property_abbd8b98b7ae46a7a589002ac361020f_Out_0_Texture2D.GetTransformedUV(_Add_ddce0338db784adda4e04a8f39383f1a_Out_2_Vector2) );
        float _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_R_4_Float = _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_RGBA_0_Vector4.r;
        float _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_G_5_Float = _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_RGBA_0_Vector4.g;
        float _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_B_6_Float = _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_RGBA_0_Vector4.b;
        float _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_A_7_Float = _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_RGBA_0_Vector4.a;
        Alpha_2 = _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_A_7_Float;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float4 SpriteMask;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_ae7bc432e6554c6b9ada42828bd9712d_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_985107d90cd443538ea364d660394913_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_ae7bc432e6554c6b9ada42828bd9712d_Out_0_Texture2D.tex, _Property_ae7bc432e6554c6b9ada42828bd9712d_Out_0_Texture2D.samplerstate, _Property_ae7bc432e6554c6b9ada42828bd9712d_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_985107d90cd443538ea364d660394913_R_4_Float = _SampleTexture2D_985107d90cd443538ea364d660394913_RGBA_0_Vector4.r;
            float _SampleTexture2D_985107d90cd443538ea364d660394913_G_5_Float = _SampleTexture2D_985107d90cd443538ea364d660394913_RGBA_0_Vector4.g;
            float _SampleTexture2D_985107d90cd443538ea364d660394913_B_6_Float = _SampleTexture2D_985107d90cd443538ea364d660394913_RGBA_0_Vector4.b;
            float _SampleTexture2D_985107d90cd443538ea364d660394913_A_7_Float = _SampleTexture2D_985107d90cd443538ea364d660394913_RGBA_0_Vector4.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Comparison_e435bc378d3e4dd781d438db02afa7cd_Out_2_Boolean;
            Unity_Comparison_GreaterOrEqual_float(_SampleTexture2D_985107d90cd443538ea364d660394913_A_7_Float, float(0.5), _Comparison_e435bc378d3e4dd781d438db02afa7cd_Out_2_Boolean);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_1e1702f4410e419490c825d0b35b2ead_Out_0_Vector4 = _OutlineColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_f06673bffc9f46cbaa5fdd8c56864327_R_1_Float = _Property_1e1702f4410e419490c825d0b35b2ead_Out_0_Vector4[0];
            float _Split_f06673bffc9f46cbaa5fdd8c56864327_G_2_Float = _Property_1e1702f4410e419490c825d0b35b2ead_Out_0_Vector4[1];
            float _Split_f06673bffc9f46cbaa5fdd8c56864327_B_3_Float = _Property_1e1702f4410e419490c825d0b35b2ead_Out_0_Vector4[2];
            float _Split_f06673bffc9f46cbaa5fdd8c56864327_A_4_Float = _Property_1e1702f4410e419490c825d0b35b2ead_Out_0_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_964062ebd2844318aaecce85d6407a73_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_a133e66273464419b8db283e3765d4a7_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_633e5b476f8a4f218e23b95ba1f10631;
            _OutlineSample_633e5b476f8a4f218e23b95ba1f10631.uv0 = IN.uv0;
            float _OutlineSample_633e5b476f8a4f218e23b95ba1f10631_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_964062ebd2844318aaecce85d6407a73_Out_0_Texture2D, _Property_a133e66273464419b8db283e3765d4a7_Out_0_Float, float2 (0, 1), _OutlineSample_633e5b476f8a4f218e23b95ba1f10631, _OutlineSample_633e5b476f8a4f218e23b95ba1f10631_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_d4732c6ac0ff4639b977cd09e6e705f6_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_e56d429a0d0a495db62b274d66870c4f_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_e9f656b9de294a17b3d5356b065c58f6;
            _OutlineSample_e9f656b9de294a17b3d5356b065c58f6.uv0 = IN.uv0;
            float _OutlineSample_e9f656b9de294a17b3d5356b065c58f6_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_d4732c6ac0ff4639b977cd09e6e705f6_Out_0_Texture2D, _Property_e56d429a0d0a495db62b274d66870c4f_Out_0_Float, float2 (0, -1), _OutlineSample_e9f656b9de294a17b3d5356b065c58f6, _OutlineSample_e9f656b9de294a17b3d5356b065c58f6_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_d7e78149c8da45d3a7a02885fb98d460_Out_2_Float;
            Unity_Add_float(_OutlineSample_633e5b476f8a4f218e23b95ba1f10631_Alpha_2_Float, _OutlineSample_e9f656b9de294a17b3d5356b065c58f6_Alpha_2_Float, _Add_d7e78149c8da45d3a7a02885fb98d460_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_281f7c4bce524bcdbb70b150cae0c970_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c6e1bc5d4dfe4fd1bad155365b74efc6_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_18a5cf1bff254092945f540376ef9b6c;
            _OutlineSample_18a5cf1bff254092945f540376ef9b6c.uv0 = IN.uv0;
            float _OutlineSample_18a5cf1bff254092945f540376ef9b6c_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_281f7c4bce524bcdbb70b150cae0c970_Out_0_Texture2D, _Property_c6e1bc5d4dfe4fd1bad155365b74efc6_Out_0_Float, float2 (1, 0), _OutlineSample_18a5cf1bff254092945f540376ef9b6c, _OutlineSample_18a5cf1bff254092945f540376ef9b6c_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_9ecb0ebafaa549d9b79b434435c20a6d_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_2fe114e1f7b6491288e88641a9bba1bf_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_fcbceaaf44a24210a84eee50850f03ec;
            _OutlineSample_fcbceaaf44a24210a84eee50850f03ec.uv0 = IN.uv0;
            float _OutlineSample_fcbceaaf44a24210a84eee50850f03ec_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_9ecb0ebafaa549d9b79b434435c20a6d_Out_0_Texture2D, _Property_2fe114e1f7b6491288e88641a9bba1bf_Out_0_Float, float2 (-1, 0), _OutlineSample_fcbceaaf44a24210a84eee50850f03ec, _OutlineSample_fcbceaaf44a24210a84eee50850f03ec_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_5381fd9c506b4ca1a0291df308debe92_Out_2_Float;
            Unity_Add_float(_OutlineSample_18a5cf1bff254092945f540376ef9b6c_Alpha_2_Float, _OutlineSample_fcbceaaf44a24210a84eee50850f03ec_Alpha_2_Float, _Add_5381fd9c506b4ca1a0291df308debe92_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_b1ef2c0c829f4c26a83ce17cc4415c6a_Out_2_Float;
            Unity_Add_float(_Add_d7e78149c8da45d3a7a02885fb98d460_Out_2_Float, _Add_5381fd9c506b4ca1a0291df308debe92_Out_2_Float, _Add_b1ef2c0c829f4c26a83ce17cc4415c6a_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_2775daa09b2840a692ff855a089d7ed1_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_a92ba799a89b44a6b9d949e33b41b045_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_a8a9a2a5b7354757a799e24f7ec630fc;
            _OutlineSample_a8a9a2a5b7354757a799e24f7ec630fc.uv0 = IN.uv0;
            float _OutlineSample_a8a9a2a5b7354757a799e24f7ec630fc_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_2775daa09b2840a692ff855a089d7ed1_Out_0_Texture2D, _Property_a92ba799a89b44a6b9d949e33b41b045_Out_0_Float, float2 (1, 1), _OutlineSample_a8a9a2a5b7354757a799e24f7ec630fc, _OutlineSample_a8a9a2a5b7354757a799e24f7ec630fc_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_99d859eee51b4036aee6d1e5cfbaf10b_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_a22cf2eeaa9b4cb8a65805cdd1d67f6c_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_bffe40f53e164140859914e99ab4a868;
            _OutlineSample_bffe40f53e164140859914e99ab4a868.uv0 = IN.uv0;
            float _OutlineSample_bffe40f53e164140859914e99ab4a868_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_99d859eee51b4036aee6d1e5cfbaf10b_Out_0_Texture2D, _Property_a22cf2eeaa9b4cb8a65805cdd1d67f6c_Out_0_Float, float2 (1, -1), _OutlineSample_bffe40f53e164140859914e99ab4a868, _OutlineSample_bffe40f53e164140859914e99ab4a868_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_9427078aaf0f459facc4660a16a48556_Out_2_Float;
            Unity_Add_float(_OutlineSample_a8a9a2a5b7354757a799e24f7ec630fc_Alpha_2_Float, _OutlineSample_bffe40f53e164140859914e99ab4a868_Alpha_2_Float, _Add_9427078aaf0f459facc4660a16a48556_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_efc8822385f042ce854597cbe6b9f331_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_17376dcd71f94a6d81dd2d819b617170_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_3faf78ef578d41b29338cc9138295682;
            _OutlineSample_3faf78ef578d41b29338cc9138295682.uv0 = IN.uv0;
            float _OutlineSample_3faf78ef578d41b29338cc9138295682_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_efc8822385f042ce854597cbe6b9f331_Out_0_Texture2D, _Property_17376dcd71f94a6d81dd2d819b617170_Out_0_Float, float2 (-1, 1), _OutlineSample_3faf78ef578d41b29338cc9138295682, _OutlineSample_3faf78ef578d41b29338cc9138295682_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_6e55c2f24312490e864ef82109702510_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_d351e64657ba42e3b753a1ff82e10dd3_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_ff2e9dbf576f411da5b766134177ce6b;
            _OutlineSample_ff2e9dbf576f411da5b766134177ce6b.uv0 = IN.uv0;
            float _OutlineSample_ff2e9dbf576f411da5b766134177ce6b_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_6e55c2f24312490e864ef82109702510_Out_0_Texture2D, _Property_d351e64657ba42e3b753a1ff82e10dd3_Out_0_Float, float2 (-1, -1), _OutlineSample_ff2e9dbf576f411da5b766134177ce6b, _OutlineSample_ff2e9dbf576f411da5b766134177ce6b_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_ed80becf447e45a29d6fd66963e31215_Out_2_Float;
            Unity_Add_float(_OutlineSample_3faf78ef578d41b29338cc9138295682_Alpha_2_Float, _OutlineSample_ff2e9dbf576f411da5b766134177ce6b_Alpha_2_Float, _Add_ed80becf447e45a29d6fd66963e31215_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_7ee20d132d374beea5660578ced0497b_Out_2_Float;
            Unity_Add_float(_Add_9427078aaf0f459facc4660a16a48556_Out_2_Float, _Add_ed80becf447e45a29d6fd66963e31215_Out_2_Float, _Add_7ee20d132d374beea5660578ced0497b_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            #if defined(CORNERS_ON)
            float _SampleCorners_3f34c98769e446ecba0e17c233b75920_Out_0_Float = _Add_7ee20d132d374beea5660578ced0497b_Out_2_Float;
            #else
            float _SampleCorners_3f34c98769e446ecba0e17c233b75920_Out_0_Float = float(0);
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_8d965d46296e46959bf62a4db31f5106_Out_2_Float;
            Unity_Add_float(_Add_b1ef2c0c829f4c26a83ce17cc4415c6a_Out_2_Float, _SampleCorners_3f34c98769e446ecba0e17c233b75920_Out_0_Float, _Add_8d965d46296e46959bf62a4db31f5106_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_176fa52fcb424f33b65b05899e55d952_Out_1_Float;
            Unity_Saturate_float(_Add_8d965d46296e46959bf62a4db31f5106_Out_2_Float, _Saturate_176fa52fcb424f33b65b05899e55d952_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Vector4_65dc117aa1d74f598a28966042ced96b_Out_0_Vector4 = float4(_Split_f06673bffc9f46cbaa5fdd8c56864327_R_1_Float, _Split_f06673bffc9f46cbaa5fdd8c56864327_G_2_Float, _Split_f06673bffc9f46cbaa5fdd8c56864327_B_3_Float, _Saturate_176fa52fcb424f33b65b05899e55d952_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Branch_63cecadb5ea441b9ac9f6a9cf1b640de_Out_3_Vector4;
            Unity_Branch_float4(_Comparison_e435bc378d3e4dd781d438db02afa7cd_Out_2_Boolean, _SampleTexture2D_985107d90cd443538ea364d660394913_RGBA_0_Vector4, _Vector4_65dc117aa1d74f598a28966042ced96b_Out_0_Vector4, _Branch_63cecadb5ea441b9ac9f6a9cf1b640de_Out_3_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_49bedf335d334a1cb82b34e3852f3369_R_1_Float = _Branch_63cecadb5ea441b9ac9f6a9cf1b640de_Out_3_Vector4[0];
            float _Split_49bedf335d334a1cb82b34e3852f3369_G_2_Float = _Branch_63cecadb5ea441b9ac9f6a9cf1b640de_Out_3_Vector4[1];
            float _Split_49bedf335d334a1cb82b34e3852f3369_B_3_Float = _Branch_63cecadb5ea441b9ac9f6a9cf1b640de_Out_3_Vector4[2];
            float _Split_49bedf335d334a1cb82b34e3852f3369_A_4_Float = _Branch_63cecadb5ea441b9ac9f6a9cf1b640de_Out_3_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Combine_f0c33f58b1c84eb28a02c6cc94112b45_RGBA_4_Vector4;
            float3 _Combine_f0c33f58b1c84eb28a02c6cc94112b45_RGB_5_Vector3;
            float2 _Combine_f0c33f58b1c84eb28a02c6cc94112b45_RG_6_Vector2;
            Unity_Combine_float(_Split_49bedf335d334a1cb82b34e3852f3369_R_1_Float, _Split_49bedf335d334a1cb82b34e3852f3369_G_2_Float, _Split_49bedf335d334a1cb82b34e3852f3369_B_3_Float, float(0), _Combine_f0c33f58b1c84eb28a02c6cc94112b45_RGBA_4_Vector4, _Combine_f0c33f58b1c84eb28a02c6cc94112b45_RGB_5_Vector3, _Combine_f0c33f58b1c84eb28a02c6cc94112b45_RG_6_Vector2);
            #endif
            surface.BaseColor = _Combine_f0c33f58b1c84eb28a02c6cc94112b45_RGB_5_Vector3;
            surface.Alpha = _Split_49bedf335d334a1cb82b34e3852f3369_A_4_Float;
            surface.SpriteMask = IsGammaSpace() ? float4(1, 1, 1, 1) : float4 (SRGBToLinear(float3(1, 1, 1)), 1);
            surface.AlphaClipThreshold = float(0.5);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =                          input.normalOS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =                        input.positionOS;
        #endif
        
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 = input.texCoord0;
        #endif
        
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/2D/ShaderGraph/Includes/SpriteLitPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "Sprite Normal"
            Tags
            {
                "LightMode" = "NormalsRendering"
            }
        
        // Render State
        Cull Off
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma exclude_renderers d3d11_9x
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        #pragma shader_feature_local _ CORNERS_ON
        
        #if defined(CORNERS_ON)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif
        
        
        // Defines
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_NORMAL_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TANGENT_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif
        
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SPRITENORMAL
        #define ALPHA_CLIP_THRESHOLD 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/NormalsRenderingShared.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv0 : TEXCOORD0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 tangentWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 TangentSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv0;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 tangentWS : INTERP0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord0 : INTERP1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 normalWS : INTERP2;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _MainTex_TexelSize;
        float _OutlineThickness;
        float4 _OutlineColor;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Comparison_GreaterOrEqual_float(float A, float B, out float Out)
        {
            Out = A >= B ? 1 : 0;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
        Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        struct Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float
        {
        half4 uv0;
        };
        
        void SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(UnityTexture2D _Texture, float _OutlineThickness, float2 _Direction, Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float IN, out float Alpha_2)
        {
        UnityTexture2D _Property_abbd8b98b7ae46a7a589002ac361020f_Out_0_Texture2D = _Texture;
        float4 _UV_28706884e92b49018cd93fc942406a75_Out_0_Vector4 = IN.uv0;
        UnityTexture2D _Property_75130dae886e4ba88386713011b81ac6_Out_0_Texture2D = _Texture;
        float _TextureSize_387b805f38414b1baee12c937d38b1c0_Width_0_Float = _Property_75130dae886e4ba88386713011b81ac6_Out_0_Texture2D.texelSize.z;
        float _TextureSize_387b805f38414b1baee12c937d38b1c0_Height_2_Float = _Property_75130dae886e4ba88386713011b81ac6_Out_0_Texture2D.texelSize.w;
        float _TextureSize_387b805f38414b1baee12c937d38b1c0_TexelWidth_3_Float = _Property_75130dae886e4ba88386713011b81ac6_Out_0_Texture2D.texelSize.x;
        float _TextureSize_387b805f38414b1baee12c937d38b1c0_TexelHeight_4_Float = _Property_75130dae886e4ba88386713011b81ac6_Out_0_Texture2D.texelSize.y;
        float2 _Vector2_6eddb764a241497e9427406cae4687a4_Out_0_Vector2 = float2(_TextureSize_387b805f38414b1baee12c937d38b1c0_TexelWidth_3_Float, _TextureSize_387b805f38414b1baee12c937d38b1c0_TexelHeight_4_Float);
        float _Property_2fe213d5a4df4752815fa1d9c39276b5_Out_0_Float = _OutlineThickness;
        float2 _Multiply_873730e798d1451e893758a79882ee2b_Out_2_Vector2;
        Unity_Multiply_float2_float2(_Vector2_6eddb764a241497e9427406cae4687a4_Out_0_Vector2, (_Property_2fe213d5a4df4752815fa1d9c39276b5_Out_0_Float.xx), _Multiply_873730e798d1451e893758a79882ee2b_Out_2_Vector2);
        float2 _Property_e60d2a2ec0b54194af044138b75995ba_Out_0_Vector2 = _Direction;
        float2 _Multiply_e4de5667f8654b52a08221801a0ada79_Out_2_Vector2;
        Unity_Multiply_float2_float2(_Multiply_873730e798d1451e893758a79882ee2b_Out_2_Vector2, _Property_e60d2a2ec0b54194af044138b75995ba_Out_0_Vector2, _Multiply_e4de5667f8654b52a08221801a0ada79_Out_2_Vector2);
        float2 _Add_ddce0338db784adda4e04a8f39383f1a_Out_2_Vector2;
        Unity_Add_float2((_UV_28706884e92b49018cd93fc942406a75_Out_0_Vector4.xy), _Multiply_e4de5667f8654b52a08221801a0ada79_Out_2_Vector2, _Add_ddce0338db784adda4e04a8f39383f1a_Out_2_Vector2);
        float4 _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_abbd8b98b7ae46a7a589002ac361020f_Out_0_Texture2D.tex, _Property_abbd8b98b7ae46a7a589002ac361020f_Out_0_Texture2D.samplerstate, _Property_abbd8b98b7ae46a7a589002ac361020f_Out_0_Texture2D.GetTransformedUV(_Add_ddce0338db784adda4e04a8f39383f1a_Out_2_Vector2) );
        float _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_R_4_Float = _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_RGBA_0_Vector4.r;
        float _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_G_5_Float = _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_RGBA_0_Vector4.g;
        float _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_B_6_Float = _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_RGBA_0_Vector4.b;
        float _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_A_7_Float = _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_RGBA_0_Vector4.a;
        Alpha_2 = _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_A_7_Float;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float3 NormalTS;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_ae7bc432e6554c6b9ada42828bd9712d_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_985107d90cd443538ea364d660394913_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_ae7bc432e6554c6b9ada42828bd9712d_Out_0_Texture2D.tex, _Property_ae7bc432e6554c6b9ada42828bd9712d_Out_0_Texture2D.samplerstate, _Property_ae7bc432e6554c6b9ada42828bd9712d_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_985107d90cd443538ea364d660394913_R_4_Float = _SampleTexture2D_985107d90cd443538ea364d660394913_RGBA_0_Vector4.r;
            float _SampleTexture2D_985107d90cd443538ea364d660394913_G_5_Float = _SampleTexture2D_985107d90cd443538ea364d660394913_RGBA_0_Vector4.g;
            float _SampleTexture2D_985107d90cd443538ea364d660394913_B_6_Float = _SampleTexture2D_985107d90cd443538ea364d660394913_RGBA_0_Vector4.b;
            float _SampleTexture2D_985107d90cd443538ea364d660394913_A_7_Float = _SampleTexture2D_985107d90cd443538ea364d660394913_RGBA_0_Vector4.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Comparison_e435bc378d3e4dd781d438db02afa7cd_Out_2_Boolean;
            Unity_Comparison_GreaterOrEqual_float(_SampleTexture2D_985107d90cd443538ea364d660394913_A_7_Float, float(0.5), _Comparison_e435bc378d3e4dd781d438db02afa7cd_Out_2_Boolean);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_1e1702f4410e419490c825d0b35b2ead_Out_0_Vector4 = _OutlineColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_f06673bffc9f46cbaa5fdd8c56864327_R_1_Float = _Property_1e1702f4410e419490c825d0b35b2ead_Out_0_Vector4[0];
            float _Split_f06673bffc9f46cbaa5fdd8c56864327_G_2_Float = _Property_1e1702f4410e419490c825d0b35b2ead_Out_0_Vector4[1];
            float _Split_f06673bffc9f46cbaa5fdd8c56864327_B_3_Float = _Property_1e1702f4410e419490c825d0b35b2ead_Out_0_Vector4[2];
            float _Split_f06673bffc9f46cbaa5fdd8c56864327_A_4_Float = _Property_1e1702f4410e419490c825d0b35b2ead_Out_0_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_964062ebd2844318aaecce85d6407a73_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_a133e66273464419b8db283e3765d4a7_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_633e5b476f8a4f218e23b95ba1f10631;
            _OutlineSample_633e5b476f8a4f218e23b95ba1f10631.uv0 = IN.uv0;
            float _OutlineSample_633e5b476f8a4f218e23b95ba1f10631_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_964062ebd2844318aaecce85d6407a73_Out_0_Texture2D, _Property_a133e66273464419b8db283e3765d4a7_Out_0_Float, float2 (0, 1), _OutlineSample_633e5b476f8a4f218e23b95ba1f10631, _OutlineSample_633e5b476f8a4f218e23b95ba1f10631_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_d4732c6ac0ff4639b977cd09e6e705f6_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_e56d429a0d0a495db62b274d66870c4f_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_e9f656b9de294a17b3d5356b065c58f6;
            _OutlineSample_e9f656b9de294a17b3d5356b065c58f6.uv0 = IN.uv0;
            float _OutlineSample_e9f656b9de294a17b3d5356b065c58f6_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_d4732c6ac0ff4639b977cd09e6e705f6_Out_0_Texture2D, _Property_e56d429a0d0a495db62b274d66870c4f_Out_0_Float, float2 (0, -1), _OutlineSample_e9f656b9de294a17b3d5356b065c58f6, _OutlineSample_e9f656b9de294a17b3d5356b065c58f6_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_d7e78149c8da45d3a7a02885fb98d460_Out_2_Float;
            Unity_Add_float(_OutlineSample_633e5b476f8a4f218e23b95ba1f10631_Alpha_2_Float, _OutlineSample_e9f656b9de294a17b3d5356b065c58f6_Alpha_2_Float, _Add_d7e78149c8da45d3a7a02885fb98d460_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_281f7c4bce524bcdbb70b150cae0c970_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c6e1bc5d4dfe4fd1bad155365b74efc6_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_18a5cf1bff254092945f540376ef9b6c;
            _OutlineSample_18a5cf1bff254092945f540376ef9b6c.uv0 = IN.uv0;
            float _OutlineSample_18a5cf1bff254092945f540376ef9b6c_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_281f7c4bce524bcdbb70b150cae0c970_Out_0_Texture2D, _Property_c6e1bc5d4dfe4fd1bad155365b74efc6_Out_0_Float, float2 (1, 0), _OutlineSample_18a5cf1bff254092945f540376ef9b6c, _OutlineSample_18a5cf1bff254092945f540376ef9b6c_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_9ecb0ebafaa549d9b79b434435c20a6d_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_2fe114e1f7b6491288e88641a9bba1bf_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_fcbceaaf44a24210a84eee50850f03ec;
            _OutlineSample_fcbceaaf44a24210a84eee50850f03ec.uv0 = IN.uv0;
            float _OutlineSample_fcbceaaf44a24210a84eee50850f03ec_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_9ecb0ebafaa549d9b79b434435c20a6d_Out_0_Texture2D, _Property_2fe114e1f7b6491288e88641a9bba1bf_Out_0_Float, float2 (-1, 0), _OutlineSample_fcbceaaf44a24210a84eee50850f03ec, _OutlineSample_fcbceaaf44a24210a84eee50850f03ec_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_5381fd9c506b4ca1a0291df308debe92_Out_2_Float;
            Unity_Add_float(_OutlineSample_18a5cf1bff254092945f540376ef9b6c_Alpha_2_Float, _OutlineSample_fcbceaaf44a24210a84eee50850f03ec_Alpha_2_Float, _Add_5381fd9c506b4ca1a0291df308debe92_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_b1ef2c0c829f4c26a83ce17cc4415c6a_Out_2_Float;
            Unity_Add_float(_Add_d7e78149c8da45d3a7a02885fb98d460_Out_2_Float, _Add_5381fd9c506b4ca1a0291df308debe92_Out_2_Float, _Add_b1ef2c0c829f4c26a83ce17cc4415c6a_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_2775daa09b2840a692ff855a089d7ed1_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_a92ba799a89b44a6b9d949e33b41b045_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_a8a9a2a5b7354757a799e24f7ec630fc;
            _OutlineSample_a8a9a2a5b7354757a799e24f7ec630fc.uv0 = IN.uv0;
            float _OutlineSample_a8a9a2a5b7354757a799e24f7ec630fc_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_2775daa09b2840a692ff855a089d7ed1_Out_0_Texture2D, _Property_a92ba799a89b44a6b9d949e33b41b045_Out_0_Float, float2 (1, 1), _OutlineSample_a8a9a2a5b7354757a799e24f7ec630fc, _OutlineSample_a8a9a2a5b7354757a799e24f7ec630fc_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_99d859eee51b4036aee6d1e5cfbaf10b_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_a22cf2eeaa9b4cb8a65805cdd1d67f6c_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_bffe40f53e164140859914e99ab4a868;
            _OutlineSample_bffe40f53e164140859914e99ab4a868.uv0 = IN.uv0;
            float _OutlineSample_bffe40f53e164140859914e99ab4a868_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_99d859eee51b4036aee6d1e5cfbaf10b_Out_0_Texture2D, _Property_a22cf2eeaa9b4cb8a65805cdd1d67f6c_Out_0_Float, float2 (1, -1), _OutlineSample_bffe40f53e164140859914e99ab4a868, _OutlineSample_bffe40f53e164140859914e99ab4a868_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_9427078aaf0f459facc4660a16a48556_Out_2_Float;
            Unity_Add_float(_OutlineSample_a8a9a2a5b7354757a799e24f7ec630fc_Alpha_2_Float, _OutlineSample_bffe40f53e164140859914e99ab4a868_Alpha_2_Float, _Add_9427078aaf0f459facc4660a16a48556_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_efc8822385f042ce854597cbe6b9f331_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_17376dcd71f94a6d81dd2d819b617170_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_3faf78ef578d41b29338cc9138295682;
            _OutlineSample_3faf78ef578d41b29338cc9138295682.uv0 = IN.uv0;
            float _OutlineSample_3faf78ef578d41b29338cc9138295682_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_efc8822385f042ce854597cbe6b9f331_Out_0_Texture2D, _Property_17376dcd71f94a6d81dd2d819b617170_Out_0_Float, float2 (-1, 1), _OutlineSample_3faf78ef578d41b29338cc9138295682, _OutlineSample_3faf78ef578d41b29338cc9138295682_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_6e55c2f24312490e864ef82109702510_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_d351e64657ba42e3b753a1ff82e10dd3_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_ff2e9dbf576f411da5b766134177ce6b;
            _OutlineSample_ff2e9dbf576f411da5b766134177ce6b.uv0 = IN.uv0;
            float _OutlineSample_ff2e9dbf576f411da5b766134177ce6b_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_6e55c2f24312490e864ef82109702510_Out_0_Texture2D, _Property_d351e64657ba42e3b753a1ff82e10dd3_Out_0_Float, float2 (-1, -1), _OutlineSample_ff2e9dbf576f411da5b766134177ce6b, _OutlineSample_ff2e9dbf576f411da5b766134177ce6b_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_ed80becf447e45a29d6fd66963e31215_Out_2_Float;
            Unity_Add_float(_OutlineSample_3faf78ef578d41b29338cc9138295682_Alpha_2_Float, _OutlineSample_ff2e9dbf576f411da5b766134177ce6b_Alpha_2_Float, _Add_ed80becf447e45a29d6fd66963e31215_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_7ee20d132d374beea5660578ced0497b_Out_2_Float;
            Unity_Add_float(_Add_9427078aaf0f459facc4660a16a48556_Out_2_Float, _Add_ed80becf447e45a29d6fd66963e31215_Out_2_Float, _Add_7ee20d132d374beea5660578ced0497b_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            #if defined(CORNERS_ON)
            float _SampleCorners_3f34c98769e446ecba0e17c233b75920_Out_0_Float = _Add_7ee20d132d374beea5660578ced0497b_Out_2_Float;
            #else
            float _SampleCorners_3f34c98769e446ecba0e17c233b75920_Out_0_Float = float(0);
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_8d965d46296e46959bf62a4db31f5106_Out_2_Float;
            Unity_Add_float(_Add_b1ef2c0c829f4c26a83ce17cc4415c6a_Out_2_Float, _SampleCorners_3f34c98769e446ecba0e17c233b75920_Out_0_Float, _Add_8d965d46296e46959bf62a4db31f5106_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_176fa52fcb424f33b65b05899e55d952_Out_1_Float;
            Unity_Saturate_float(_Add_8d965d46296e46959bf62a4db31f5106_Out_2_Float, _Saturate_176fa52fcb424f33b65b05899e55d952_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Vector4_65dc117aa1d74f598a28966042ced96b_Out_0_Vector4 = float4(_Split_f06673bffc9f46cbaa5fdd8c56864327_R_1_Float, _Split_f06673bffc9f46cbaa5fdd8c56864327_G_2_Float, _Split_f06673bffc9f46cbaa5fdd8c56864327_B_3_Float, _Saturate_176fa52fcb424f33b65b05899e55d952_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Branch_63cecadb5ea441b9ac9f6a9cf1b640de_Out_3_Vector4;
            Unity_Branch_float4(_Comparison_e435bc378d3e4dd781d438db02afa7cd_Out_2_Boolean, _SampleTexture2D_985107d90cd443538ea364d660394913_RGBA_0_Vector4, _Vector4_65dc117aa1d74f598a28966042ced96b_Out_0_Vector4, _Branch_63cecadb5ea441b9ac9f6a9cf1b640de_Out_3_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_49bedf335d334a1cb82b34e3852f3369_R_1_Float = _Branch_63cecadb5ea441b9ac9f6a9cf1b640de_Out_3_Vector4[0];
            float _Split_49bedf335d334a1cb82b34e3852f3369_G_2_Float = _Branch_63cecadb5ea441b9ac9f6a9cf1b640de_Out_3_Vector4[1];
            float _Split_49bedf335d334a1cb82b34e3852f3369_B_3_Float = _Branch_63cecadb5ea441b9ac9f6a9cf1b640de_Out_3_Vector4[2];
            float _Split_49bedf335d334a1cb82b34e3852f3369_A_4_Float = _Branch_63cecadb5ea441b9ac9f6a9cf1b640de_Out_3_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Combine_f0c33f58b1c84eb28a02c6cc94112b45_RGBA_4_Vector4;
            float3 _Combine_f0c33f58b1c84eb28a02c6cc94112b45_RGB_5_Vector3;
            float2 _Combine_f0c33f58b1c84eb28a02c6cc94112b45_RG_6_Vector2;
            Unity_Combine_float(_Split_49bedf335d334a1cb82b34e3852f3369_R_1_Float, _Split_49bedf335d334a1cb82b34e3852f3369_G_2_Float, _Split_49bedf335d334a1cb82b34e3852f3369_B_3_Float, float(0), _Combine_f0c33f58b1c84eb28a02c6cc94112b45_RGBA_4_Vector4, _Combine_f0c33f58b1c84eb28a02c6cc94112b45_RGB_5_Vector3, _Combine_f0c33f58b1c84eb28a02c6cc94112b45_RG_6_Vector2);
            #endif
            surface.BaseColor = _Combine_f0c33f58b1c84eb28a02c6cc94112b45_RGB_5_Vector3;
            surface.Alpha = _Split_49bedf335d334a1cb82b34e3852f3369_A_4_Float;
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.AlphaClipThreshold = float(0.5);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =                          input.normalOS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =                        input.positionOS;
        #endif
        
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        #endif
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 = input.texCoord0;
        #endif
        
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/2D/ShaderGraph/Includes/SpriteNormalPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma exclude_renderers d3d11_9x
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        #pragma shader_feature_local _ CORNERS_ON
        
        #if defined(CORNERS_ON)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif
        
        
        // Defines
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif
        
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        
        #define _ALPHATEST_ON 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv0 : TEXCOORD0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv0;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord0 : INTERP0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _MainTex_TexelSize;
        float _OutlineThickness;
        float4 _OutlineColor;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Comparison_GreaterOrEqual_float(float A, float B, out float Out)
        {
            Out = A >= B ? 1 : 0;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
        Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        struct Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float
        {
        half4 uv0;
        };
        
        void SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(UnityTexture2D _Texture, float _OutlineThickness, float2 _Direction, Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float IN, out float Alpha_2)
        {
        UnityTexture2D _Property_abbd8b98b7ae46a7a589002ac361020f_Out_0_Texture2D = _Texture;
        float4 _UV_28706884e92b49018cd93fc942406a75_Out_0_Vector4 = IN.uv0;
        UnityTexture2D _Property_75130dae886e4ba88386713011b81ac6_Out_0_Texture2D = _Texture;
        float _TextureSize_387b805f38414b1baee12c937d38b1c0_Width_0_Float = _Property_75130dae886e4ba88386713011b81ac6_Out_0_Texture2D.texelSize.z;
        float _TextureSize_387b805f38414b1baee12c937d38b1c0_Height_2_Float = _Property_75130dae886e4ba88386713011b81ac6_Out_0_Texture2D.texelSize.w;
        float _TextureSize_387b805f38414b1baee12c937d38b1c0_TexelWidth_3_Float = _Property_75130dae886e4ba88386713011b81ac6_Out_0_Texture2D.texelSize.x;
        float _TextureSize_387b805f38414b1baee12c937d38b1c0_TexelHeight_4_Float = _Property_75130dae886e4ba88386713011b81ac6_Out_0_Texture2D.texelSize.y;
        float2 _Vector2_6eddb764a241497e9427406cae4687a4_Out_0_Vector2 = float2(_TextureSize_387b805f38414b1baee12c937d38b1c0_TexelWidth_3_Float, _TextureSize_387b805f38414b1baee12c937d38b1c0_TexelHeight_4_Float);
        float _Property_2fe213d5a4df4752815fa1d9c39276b5_Out_0_Float = _OutlineThickness;
        float2 _Multiply_873730e798d1451e893758a79882ee2b_Out_2_Vector2;
        Unity_Multiply_float2_float2(_Vector2_6eddb764a241497e9427406cae4687a4_Out_0_Vector2, (_Property_2fe213d5a4df4752815fa1d9c39276b5_Out_0_Float.xx), _Multiply_873730e798d1451e893758a79882ee2b_Out_2_Vector2);
        float2 _Property_e60d2a2ec0b54194af044138b75995ba_Out_0_Vector2 = _Direction;
        float2 _Multiply_e4de5667f8654b52a08221801a0ada79_Out_2_Vector2;
        Unity_Multiply_float2_float2(_Multiply_873730e798d1451e893758a79882ee2b_Out_2_Vector2, _Property_e60d2a2ec0b54194af044138b75995ba_Out_0_Vector2, _Multiply_e4de5667f8654b52a08221801a0ada79_Out_2_Vector2);
        float2 _Add_ddce0338db784adda4e04a8f39383f1a_Out_2_Vector2;
        Unity_Add_float2((_UV_28706884e92b49018cd93fc942406a75_Out_0_Vector4.xy), _Multiply_e4de5667f8654b52a08221801a0ada79_Out_2_Vector2, _Add_ddce0338db784adda4e04a8f39383f1a_Out_2_Vector2);
        float4 _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_abbd8b98b7ae46a7a589002ac361020f_Out_0_Texture2D.tex, _Property_abbd8b98b7ae46a7a589002ac361020f_Out_0_Texture2D.samplerstate, _Property_abbd8b98b7ae46a7a589002ac361020f_Out_0_Texture2D.GetTransformedUV(_Add_ddce0338db784adda4e04a8f39383f1a_Out_2_Vector2) );
        float _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_R_4_Float = _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_RGBA_0_Vector4.r;
        float _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_G_5_Float = _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_RGBA_0_Vector4.g;
        float _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_B_6_Float = _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_RGBA_0_Vector4.b;
        float _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_A_7_Float = _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_RGBA_0_Vector4.a;
        Alpha_2 = _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_A_7_Float;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_ae7bc432e6554c6b9ada42828bd9712d_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_985107d90cd443538ea364d660394913_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_ae7bc432e6554c6b9ada42828bd9712d_Out_0_Texture2D.tex, _Property_ae7bc432e6554c6b9ada42828bd9712d_Out_0_Texture2D.samplerstate, _Property_ae7bc432e6554c6b9ada42828bd9712d_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_985107d90cd443538ea364d660394913_R_4_Float = _SampleTexture2D_985107d90cd443538ea364d660394913_RGBA_0_Vector4.r;
            float _SampleTexture2D_985107d90cd443538ea364d660394913_G_5_Float = _SampleTexture2D_985107d90cd443538ea364d660394913_RGBA_0_Vector4.g;
            float _SampleTexture2D_985107d90cd443538ea364d660394913_B_6_Float = _SampleTexture2D_985107d90cd443538ea364d660394913_RGBA_0_Vector4.b;
            float _SampleTexture2D_985107d90cd443538ea364d660394913_A_7_Float = _SampleTexture2D_985107d90cd443538ea364d660394913_RGBA_0_Vector4.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Comparison_e435bc378d3e4dd781d438db02afa7cd_Out_2_Boolean;
            Unity_Comparison_GreaterOrEqual_float(_SampleTexture2D_985107d90cd443538ea364d660394913_A_7_Float, float(0.5), _Comparison_e435bc378d3e4dd781d438db02afa7cd_Out_2_Boolean);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_1e1702f4410e419490c825d0b35b2ead_Out_0_Vector4 = _OutlineColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_f06673bffc9f46cbaa5fdd8c56864327_R_1_Float = _Property_1e1702f4410e419490c825d0b35b2ead_Out_0_Vector4[0];
            float _Split_f06673bffc9f46cbaa5fdd8c56864327_G_2_Float = _Property_1e1702f4410e419490c825d0b35b2ead_Out_0_Vector4[1];
            float _Split_f06673bffc9f46cbaa5fdd8c56864327_B_3_Float = _Property_1e1702f4410e419490c825d0b35b2ead_Out_0_Vector4[2];
            float _Split_f06673bffc9f46cbaa5fdd8c56864327_A_4_Float = _Property_1e1702f4410e419490c825d0b35b2ead_Out_0_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_964062ebd2844318aaecce85d6407a73_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_a133e66273464419b8db283e3765d4a7_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_633e5b476f8a4f218e23b95ba1f10631;
            _OutlineSample_633e5b476f8a4f218e23b95ba1f10631.uv0 = IN.uv0;
            float _OutlineSample_633e5b476f8a4f218e23b95ba1f10631_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_964062ebd2844318aaecce85d6407a73_Out_0_Texture2D, _Property_a133e66273464419b8db283e3765d4a7_Out_0_Float, float2 (0, 1), _OutlineSample_633e5b476f8a4f218e23b95ba1f10631, _OutlineSample_633e5b476f8a4f218e23b95ba1f10631_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_d4732c6ac0ff4639b977cd09e6e705f6_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_e56d429a0d0a495db62b274d66870c4f_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_e9f656b9de294a17b3d5356b065c58f6;
            _OutlineSample_e9f656b9de294a17b3d5356b065c58f6.uv0 = IN.uv0;
            float _OutlineSample_e9f656b9de294a17b3d5356b065c58f6_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_d4732c6ac0ff4639b977cd09e6e705f6_Out_0_Texture2D, _Property_e56d429a0d0a495db62b274d66870c4f_Out_0_Float, float2 (0, -1), _OutlineSample_e9f656b9de294a17b3d5356b065c58f6, _OutlineSample_e9f656b9de294a17b3d5356b065c58f6_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_d7e78149c8da45d3a7a02885fb98d460_Out_2_Float;
            Unity_Add_float(_OutlineSample_633e5b476f8a4f218e23b95ba1f10631_Alpha_2_Float, _OutlineSample_e9f656b9de294a17b3d5356b065c58f6_Alpha_2_Float, _Add_d7e78149c8da45d3a7a02885fb98d460_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_281f7c4bce524bcdbb70b150cae0c970_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c6e1bc5d4dfe4fd1bad155365b74efc6_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_18a5cf1bff254092945f540376ef9b6c;
            _OutlineSample_18a5cf1bff254092945f540376ef9b6c.uv0 = IN.uv0;
            float _OutlineSample_18a5cf1bff254092945f540376ef9b6c_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_281f7c4bce524bcdbb70b150cae0c970_Out_0_Texture2D, _Property_c6e1bc5d4dfe4fd1bad155365b74efc6_Out_0_Float, float2 (1, 0), _OutlineSample_18a5cf1bff254092945f540376ef9b6c, _OutlineSample_18a5cf1bff254092945f540376ef9b6c_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_9ecb0ebafaa549d9b79b434435c20a6d_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_2fe114e1f7b6491288e88641a9bba1bf_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_fcbceaaf44a24210a84eee50850f03ec;
            _OutlineSample_fcbceaaf44a24210a84eee50850f03ec.uv0 = IN.uv0;
            float _OutlineSample_fcbceaaf44a24210a84eee50850f03ec_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_9ecb0ebafaa549d9b79b434435c20a6d_Out_0_Texture2D, _Property_2fe114e1f7b6491288e88641a9bba1bf_Out_0_Float, float2 (-1, 0), _OutlineSample_fcbceaaf44a24210a84eee50850f03ec, _OutlineSample_fcbceaaf44a24210a84eee50850f03ec_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_5381fd9c506b4ca1a0291df308debe92_Out_2_Float;
            Unity_Add_float(_OutlineSample_18a5cf1bff254092945f540376ef9b6c_Alpha_2_Float, _OutlineSample_fcbceaaf44a24210a84eee50850f03ec_Alpha_2_Float, _Add_5381fd9c506b4ca1a0291df308debe92_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_b1ef2c0c829f4c26a83ce17cc4415c6a_Out_2_Float;
            Unity_Add_float(_Add_d7e78149c8da45d3a7a02885fb98d460_Out_2_Float, _Add_5381fd9c506b4ca1a0291df308debe92_Out_2_Float, _Add_b1ef2c0c829f4c26a83ce17cc4415c6a_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_2775daa09b2840a692ff855a089d7ed1_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_a92ba799a89b44a6b9d949e33b41b045_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_a8a9a2a5b7354757a799e24f7ec630fc;
            _OutlineSample_a8a9a2a5b7354757a799e24f7ec630fc.uv0 = IN.uv0;
            float _OutlineSample_a8a9a2a5b7354757a799e24f7ec630fc_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_2775daa09b2840a692ff855a089d7ed1_Out_0_Texture2D, _Property_a92ba799a89b44a6b9d949e33b41b045_Out_0_Float, float2 (1, 1), _OutlineSample_a8a9a2a5b7354757a799e24f7ec630fc, _OutlineSample_a8a9a2a5b7354757a799e24f7ec630fc_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_99d859eee51b4036aee6d1e5cfbaf10b_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_a22cf2eeaa9b4cb8a65805cdd1d67f6c_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_bffe40f53e164140859914e99ab4a868;
            _OutlineSample_bffe40f53e164140859914e99ab4a868.uv0 = IN.uv0;
            float _OutlineSample_bffe40f53e164140859914e99ab4a868_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_99d859eee51b4036aee6d1e5cfbaf10b_Out_0_Texture2D, _Property_a22cf2eeaa9b4cb8a65805cdd1d67f6c_Out_0_Float, float2 (1, -1), _OutlineSample_bffe40f53e164140859914e99ab4a868, _OutlineSample_bffe40f53e164140859914e99ab4a868_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_9427078aaf0f459facc4660a16a48556_Out_2_Float;
            Unity_Add_float(_OutlineSample_a8a9a2a5b7354757a799e24f7ec630fc_Alpha_2_Float, _OutlineSample_bffe40f53e164140859914e99ab4a868_Alpha_2_Float, _Add_9427078aaf0f459facc4660a16a48556_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_efc8822385f042ce854597cbe6b9f331_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_17376dcd71f94a6d81dd2d819b617170_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_3faf78ef578d41b29338cc9138295682;
            _OutlineSample_3faf78ef578d41b29338cc9138295682.uv0 = IN.uv0;
            float _OutlineSample_3faf78ef578d41b29338cc9138295682_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_efc8822385f042ce854597cbe6b9f331_Out_0_Texture2D, _Property_17376dcd71f94a6d81dd2d819b617170_Out_0_Float, float2 (-1, 1), _OutlineSample_3faf78ef578d41b29338cc9138295682, _OutlineSample_3faf78ef578d41b29338cc9138295682_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_6e55c2f24312490e864ef82109702510_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_d351e64657ba42e3b753a1ff82e10dd3_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_ff2e9dbf576f411da5b766134177ce6b;
            _OutlineSample_ff2e9dbf576f411da5b766134177ce6b.uv0 = IN.uv0;
            float _OutlineSample_ff2e9dbf576f411da5b766134177ce6b_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_6e55c2f24312490e864ef82109702510_Out_0_Texture2D, _Property_d351e64657ba42e3b753a1ff82e10dd3_Out_0_Float, float2 (-1, -1), _OutlineSample_ff2e9dbf576f411da5b766134177ce6b, _OutlineSample_ff2e9dbf576f411da5b766134177ce6b_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_ed80becf447e45a29d6fd66963e31215_Out_2_Float;
            Unity_Add_float(_OutlineSample_3faf78ef578d41b29338cc9138295682_Alpha_2_Float, _OutlineSample_ff2e9dbf576f411da5b766134177ce6b_Alpha_2_Float, _Add_ed80becf447e45a29d6fd66963e31215_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_7ee20d132d374beea5660578ced0497b_Out_2_Float;
            Unity_Add_float(_Add_9427078aaf0f459facc4660a16a48556_Out_2_Float, _Add_ed80becf447e45a29d6fd66963e31215_Out_2_Float, _Add_7ee20d132d374beea5660578ced0497b_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            #if defined(CORNERS_ON)
            float _SampleCorners_3f34c98769e446ecba0e17c233b75920_Out_0_Float = _Add_7ee20d132d374beea5660578ced0497b_Out_2_Float;
            #else
            float _SampleCorners_3f34c98769e446ecba0e17c233b75920_Out_0_Float = float(0);
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_8d965d46296e46959bf62a4db31f5106_Out_2_Float;
            Unity_Add_float(_Add_b1ef2c0c829f4c26a83ce17cc4415c6a_Out_2_Float, _SampleCorners_3f34c98769e446ecba0e17c233b75920_Out_0_Float, _Add_8d965d46296e46959bf62a4db31f5106_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_176fa52fcb424f33b65b05899e55d952_Out_1_Float;
            Unity_Saturate_float(_Add_8d965d46296e46959bf62a4db31f5106_Out_2_Float, _Saturate_176fa52fcb424f33b65b05899e55d952_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Vector4_65dc117aa1d74f598a28966042ced96b_Out_0_Vector4 = float4(_Split_f06673bffc9f46cbaa5fdd8c56864327_R_1_Float, _Split_f06673bffc9f46cbaa5fdd8c56864327_G_2_Float, _Split_f06673bffc9f46cbaa5fdd8c56864327_B_3_Float, _Saturate_176fa52fcb424f33b65b05899e55d952_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Branch_63cecadb5ea441b9ac9f6a9cf1b640de_Out_3_Vector4;
            Unity_Branch_float4(_Comparison_e435bc378d3e4dd781d438db02afa7cd_Out_2_Boolean, _SampleTexture2D_985107d90cd443538ea364d660394913_RGBA_0_Vector4, _Vector4_65dc117aa1d74f598a28966042ced96b_Out_0_Vector4, _Branch_63cecadb5ea441b9ac9f6a9cf1b640de_Out_3_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_49bedf335d334a1cb82b34e3852f3369_R_1_Float = _Branch_63cecadb5ea441b9ac9f6a9cf1b640de_Out_3_Vector4[0];
            float _Split_49bedf335d334a1cb82b34e3852f3369_G_2_Float = _Branch_63cecadb5ea441b9ac9f6a9cf1b640de_Out_3_Vector4[1];
            float _Split_49bedf335d334a1cb82b34e3852f3369_B_3_Float = _Branch_63cecadb5ea441b9ac9f6a9cf1b640de_Out_3_Vector4[2];
            float _Split_49bedf335d334a1cb82b34e3852f3369_A_4_Float = _Branch_63cecadb5ea441b9ac9f6a9cf1b640de_Out_3_Vector4[3];
            #endif
            surface.Alpha = _Split_49bedf335d334a1cb82b34e3852f3369_A_4_Float;
            surface.AlphaClipThreshold = float(0.5);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =                          input.normalOS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =                        input.positionOS;
        #endif
        
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 = input.texCoord0;
        #endif
        
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
        // Render State
        Cull Back
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma exclude_renderers d3d11_9x
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        #pragma shader_feature_local _ CORNERS_ON
        
        #if defined(CORNERS_ON)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif
        
        
        // Defines
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif
        
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        
        #define _ALPHATEST_ON 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv0 : TEXCOORD0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv0;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord0 : INTERP0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _MainTex_TexelSize;
        float _OutlineThickness;
        float4 _OutlineColor;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Comparison_GreaterOrEqual_float(float A, float B, out float Out)
        {
            Out = A >= B ? 1 : 0;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
        Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        struct Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float
        {
        half4 uv0;
        };
        
        void SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(UnityTexture2D _Texture, float _OutlineThickness, float2 _Direction, Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float IN, out float Alpha_2)
        {
        UnityTexture2D _Property_abbd8b98b7ae46a7a589002ac361020f_Out_0_Texture2D = _Texture;
        float4 _UV_28706884e92b49018cd93fc942406a75_Out_0_Vector4 = IN.uv0;
        UnityTexture2D _Property_75130dae886e4ba88386713011b81ac6_Out_0_Texture2D = _Texture;
        float _TextureSize_387b805f38414b1baee12c937d38b1c0_Width_0_Float = _Property_75130dae886e4ba88386713011b81ac6_Out_0_Texture2D.texelSize.z;
        float _TextureSize_387b805f38414b1baee12c937d38b1c0_Height_2_Float = _Property_75130dae886e4ba88386713011b81ac6_Out_0_Texture2D.texelSize.w;
        float _TextureSize_387b805f38414b1baee12c937d38b1c0_TexelWidth_3_Float = _Property_75130dae886e4ba88386713011b81ac6_Out_0_Texture2D.texelSize.x;
        float _TextureSize_387b805f38414b1baee12c937d38b1c0_TexelHeight_4_Float = _Property_75130dae886e4ba88386713011b81ac6_Out_0_Texture2D.texelSize.y;
        float2 _Vector2_6eddb764a241497e9427406cae4687a4_Out_0_Vector2 = float2(_TextureSize_387b805f38414b1baee12c937d38b1c0_TexelWidth_3_Float, _TextureSize_387b805f38414b1baee12c937d38b1c0_TexelHeight_4_Float);
        float _Property_2fe213d5a4df4752815fa1d9c39276b5_Out_0_Float = _OutlineThickness;
        float2 _Multiply_873730e798d1451e893758a79882ee2b_Out_2_Vector2;
        Unity_Multiply_float2_float2(_Vector2_6eddb764a241497e9427406cae4687a4_Out_0_Vector2, (_Property_2fe213d5a4df4752815fa1d9c39276b5_Out_0_Float.xx), _Multiply_873730e798d1451e893758a79882ee2b_Out_2_Vector2);
        float2 _Property_e60d2a2ec0b54194af044138b75995ba_Out_0_Vector2 = _Direction;
        float2 _Multiply_e4de5667f8654b52a08221801a0ada79_Out_2_Vector2;
        Unity_Multiply_float2_float2(_Multiply_873730e798d1451e893758a79882ee2b_Out_2_Vector2, _Property_e60d2a2ec0b54194af044138b75995ba_Out_0_Vector2, _Multiply_e4de5667f8654b52a08221801a0ada79_Out_2_Vector2);
        float2 _Add_ddce0338db784adda4e04a8f39383f1a_Out_2_Vector2;
        Unity_Add_float2((_UV_28706884e92b49018cd93fc942406a75_Out_0_Vector4.xy), _Multiply_e4de5667f8654b52a08221801a0ada79_Out_2_Vector2, _Add_ddce0338db784adda4e04a8f39383f1a_Out_2_Vector2);
        float4 _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_abbd8b98b7ae46a7a589002ac361020f_Out_0_Texture2D.tex, _Property_abbd8b98b7ae46a7a589002ac361020f_Out_0_Texture2D.samplerstate, _Property_abbd8b98b7ae46a7a589002ac361020f_Out_0_Texture2D.GetTransformedUV(_Add_ddce0338db784adda4e04a8f39383f1a_Out_2_Vector2) );
        float _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_R_4_Float = _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_RGBA_0_Vector4.r;
        float _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_G_5_Float = _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_RGBA_0_Vector4.g;
        float _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_B_6_Float = _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_RGBA_0_Vector4.b;
        float _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_A_7_Float = _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_RGBA_0_Vector4.a;
        Alpha_2 = _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_A_7_Float;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_ae7bc432e6554c6b9ada42828bd9712d_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_985107d90cd443538ea364d660394913_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_ae7bc432e6554c6b9ada42828bd9712d_Out_0_Texture2D.tex, _Property_ae7bc432e6554c6b9ada42828bd9712d_Out_0_Texture2D.samplerstate, _Property_ae7bc432e6554c6b9ada42828bd9712d_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_985107d90cd443538ea364d660394913_R_4_Float = _SampleTexture2D_985107d90cd443538ea364d660394913_RGBA_0_Vector4.r;
            float _SampleTexture2D_985107d90cd443538ea364d660394913_G_5_Float = _SampleTexture2D_985107d90cd443538ea364d660394913_RGBA_0_Vector4.g;
            float _SampleTexture2D_985107d90cd443538ea364d660394913_B_6_Float = _SampleTexture2D_985107d90cd443538ea364d660394913_RGBA_0_Vector4.b;
            float _SampleTexture2D_985107d90cd443538ea364d660394913_A_7_Float = _SampleTexture2D_985107d90cd443538ea364d660394913_RGBA_0_Vector4.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Comparison_e435bc378d3e4dd781d438db02afa7cd_Out_2_Boolean;
            Unity_Comparison_GreaterOrEqual_float(_SampleTexture2D_985107d90cd443538ea364d660394913_A_7_Float, float(0.5), _Comparison_e435bc378d3e4dd781d438db02afa7cd_Out_2_Boolean);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_1e1702f4410e419490c825d0b35b2ead_Out_0_Vector4 = _OutlineColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_f06673bffc9f46cbaa5fdd8c56864327_R_1_Float = _Property_1e1702f4410e419490c825d0b35b2ead_Out_0_Vector4[0];
            float _Split_f06673bffc9f46cbaa5fdd8c56864327_G_2_Float = _Property_1e1702f4410e419490c825d0b35b2ead_Out_0_Vector4[1];
            float _Split_f06673bffc9f46cbaa5fdd8c56864327_B_3_Float = _Property_1e1702f4410e419490c825d0b35b2ead_Out_0_Vector4[2];
            float _Split_f06673bffc9f46cbaa5fdd8c56864327_A_4_Float = _Property_1e1702f4410e419490c825d0b35b2ead_Out_0_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_964062ebd2844318aaecce85d6407a73_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_a133e66273464419b8db283e3765d4a7_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_633e5b476f8a4f218e23b95ba1f10631;
            _OutlineSample_633e5b476f8a4f218e23b95ba1f10631.uv0 = IN.uv0;
            float _OutlineSample_633e5b476f8a4f218e23b95ba1f10631_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_964062ebd2844318aaecce85d6407a73_Out_0_Texture2D, _Property_a133e66273464419b8db283e3765d4a7_Out_0_Float, float2 (0, 1), _OutlineSample_633e5b476f8a4f218e23b95ba1f10631, _OutlineSample_633e5b476f8a4f218e23b95ba1f10631_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_d4732c6ac0ff4639b977cd09e6e705f6_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_e56d429a0d0a495db62b274d66870c4f_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_e9f656b9de294a17b3d5356b065c58f6;
            _OutlineSample_e9f656b9de294a17b3d5356b065c58f6.uv0 = IN.uv0;
            float _OutlineSample_e9f656b9de294a17b3d5356b065c58f6_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_d4732c6ac0ff4639b977cd09e6e705f6_Out_0_Texture2D, _Property_e56d429a0d0a495db62b274d66870c4f_Out_0_Float, float2 (0, -1), _OutlineSample_e9f656b9de294a17b3d5356b065c58f6, _OutlineSample_e9f656b9de294a17b3d5356b065c58f6_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_d7e78149c8da45d3a7a02885fb98d460_Out_2_Float;
            Unity_Add_float(_OutlineSample_633e5b476f8a4f218e23b95ba1f10631_Alpha_2_Float, _OutlineSample_e9f656b9de294a17b3d5356b065c58f6_Alpha_2_Float, _Add_d7e78149c8da45d3a7a02885fb98d460_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_281f7c4bce524bcdbb70b150cae0c970_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c6e1bc5d4dfe4fd1bad155365b74efc6_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_18a5cf1bff254092945f540376ef9b6c;
            _OutlineSample_18a5cf1bff254092945f540376ef9b6c.uv0 = IN.uv0;
            float _OutlineSample_18a5cf1bff254092945f540376ef9b6c_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_281f7c4bce524bcdbb70b150cae0c970_Out_0_Texture2D, _Property_c6e1bc5d4dfe4fd1bad155365b74efc6_Out_0_Float, float2 (1, 0), _OutlineSample_18a5cf1bff254092945f540376ef9b6c, _OutlineSample_18a5cf1bff254092945f540376ef9b6c_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_9ecb0ebafaa549d9b79b434435c20a6d_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_2fe114e1f7b6491288e88641a9bba1bf_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_fcbceaaf44a24210a84eee50850f03ec;
            _OutlineSample_fcbceaaf44a24210a84eee50850f03ec.uv0 = IN.uv0;
            float _OutlineSample_fcbceaaf44a24210a84eee50850f03ec_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_9ecb0ebafaa549d9b79b434435c20a6d_Out_0_Texture2D, _Property_2fe114e1f7b6491288e88641a9bba1bf_Out_0_Float, float2 (-1, 0), _OutlineSample_fcbceaaf44a24210a84eee50850f03ec, _OutlineSample_fcbceaaf44a24210a84eee50850f03ec_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_5381fd9c506b4ca1a0291df308debe92_Out_2_Float;
            Unity_Add_float(_OutlineSample_18a5cf1bff254092945f540376ef9b6c_Alpha_2_Float, _OutlineSample_fcbceaaf44a24210a84eee50850f03ec_Alpha_2_Float, _Add_5381fd9c506b4ca1a0291df308debe92_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_b1ef2c0c829f4c26a83ce17cc4415c6a_Out_2_Float;
            Unity_Add_float(_Add_d7e78149c8da45d3a7a02885fb98d460_Out_2_Float, _Add_5381fd9c506b4ca1a0291df308debe92_Out_2_Float, _Add_b1ef2c0c829f4c26a83ce17cc4415c6a_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_2775daa09b2840a692ff855a089d7ed1_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_a92ba799a89b44a6b9d949e33b41b045_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_a8a9a2a5b7354757a799e24f7ec630fc;
            _OutlineSample_a8a9a2a5b7354757a799e24f7ec630fc.uv0 = IN.uv0;
            float _OutlineSample_a8a9a2a5b7354757a799e24f7ec630fc_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_2775daa09b2840a692ff855a089d7ed1_Out_0_Texture2D, _Property_a92ba799a89b44a6b9d949e33b41b045_Out_0_Float, float2 (1, 1), _OutlineSample_a8a9a2a5b7354757a799e24f7ec630fc, _OutlineSample_a8a9a2a5b7354757a799e24f7ec630fc_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_99d859eee51b4036aee6d1e5cfbaf10b_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_a22cf2eeaa9b4cb8a65805cdd1d67f6c_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_bffe40f53e164140859914e99ab4a868;
            _OutlineSample_bffe40f53e164140859914e99ab4a868.uv0 = IN.uv0;
            float _OutlineSample_bffe40f53e164140859914e99ab4a868_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_99d859eee51b4036aee6d1e5cfbaf10b_Out_0_Texture2D, _Property_a22cf2eeaa9b4cb8a65805cdd1d67f6c_Out_0_Float, float2 (1, -1), _OutlineSample_bffe40f53e164140859914e99ab4a868, _OutlineSample_bffe40f53e164140859914e99ab4a868_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_9427078aaf0f459facc4660a16a48556_Out_2_Float;
            Unity_Add_float(_OutlineSample_a8a9a2a5b7354757a799e24f7ec630fc_Alpha_2_Float, _OutlineSample_bffe40f53e164140859914e99ab4a868_Alpha_2_Float, _Add_9427078aaf0f459facc4660a16a48556_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_efc8822385f042ce854597cbe6b9f331_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_17376dcd71f94a6d81dd2d819b617170_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_3faf78ef578d41b29338cc9138295682;
            _OutlineSample_3faf78ef578d41b29338cc9138295682.uv0 = IN.uv0;
            float _OutlineSample_3faf78ef578d41b29338cc9138295682_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_efc8822385f042ce854597cbe6b9f331_Out_0_Texture2D, _Property_17376dcd71f94a6d81dd2d819b617170_Out_0_Float, float2 (-1, 1), _OutlineSample_3faf78ef578d41b29338cc9138295682, _OutlineSample_3faf78ef578d41b29338cc9138295682_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_6e55c2f24312490e864ef82109702510_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_d351e64657ba42e3b753a1ff82e10dd3_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_ff2e9dbf576f411da5b766134177ce6b;
            _OutlineSample_ff2e9dbf576f411da5b766134177ce6b.uv0 = IN.uv0;
            float _OutlineSample_ff2e9dbf576f411da5b766134177ce6b_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_6e55c2f24312490e864ef82109702510_Out_0_Texture2D, _Property_d351e64657ba42e3b753a1ff82e10dd3_Out_0_Float, float2 (-1, -1), _OutlineSample_ff2e9dbf576f411da5b766134177ce6b, _OutlineSample_ff2e9dbf576f411da5b766134177ce6b_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_ed80becf447e45a29d6fd66963e31215_Out_2_Float;
            Unity_Add_float(_OutlineSample_3faf78ef578d41b29338cc9138295682_Alpha_2_Float, _OutlineSample_ff2e9dbf576f411da5b766134177ce6b_Alpha_2_Float, _Add_ed80becf447e45a29d6fd66963e31215_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_7ee20d132d374beea5660578ced0497b_Out_2_Float;
            Unity_Add_float(_Add_9427078aaf0f459facc4660a16a48556_Out_2_Float, _Add_ed80becf447e45a29d6fd66963e31215_Out_2_Float, _Add_7ee20d132d374beea5660578ced0497b_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            #if defined(CORNERS_ON)
            float _SampleCorners_3f34c98769e446ecba0e17c233b75920_Out_0_Float = _Add_7ee20d132d374beea5660578ced0497b_Out_2_Float;
            #else
            float _SampleCorners_3f34c98769e446ecba0e17c233b75920_Out_0_Float = float(0);
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_8d965d46296e46959bf62a4db31f5106_Out_2_Float;
            Unity_Add_float(_Add_b1ef2c0c829f4c26a83ce17cc4415c6a_Out_2_Float, _SampleCorners_3f34c98769e446ecba0e17c233b75920_Out_0_Float, _Add_8d965d46296e46959bf62a4db31f5106_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_176fa52fcb424f33b65b05899e55d952_Out_1_Float;
            Unity_Saturate_float(_Add_8d965d46296e46959bf62a4db31f5106_Out_2_Float, _Saturate_176fa52fcb424f33b65b05899e55d952_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Vector4_65dc117aa1d74f598a28966042ced96b_Out_0_Vector4 = float4(_Split_f06673bffc9f46cbaa5fdd8c56864327_R_1_Float, _Split_f06673bffc9f46cbaa5fdd8c56864327_G_2_Float, _Split_f06673bffc9f46cbaa5fdd8c56864327_B_3_Float, _Saturate_176fa52fcb424f33b65b05899e55d952_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Branch_63cecadb5ea441b9ac9f6a9cf1b640de_Out_3_Vector4;
            Unity_Branch_float4(_Comparison_e435bc378d3e4dd781d438db02afa7cd_Out_2_Boolean, _SampleTexture2D_985107d90cd443538ea364d660394913_RGBA_0_Vector4, _Vector4_65dc117aa1d74f598a28966042ced96b_Out_0_Vector4, _Branch_63cecadb5ea441b9ac9f6a9cf1b640de_Out_3_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_49bedf335d334a1cb82b34e3852f3369_R_1_Float = _Branch_63cecadb5ea441b9ac9f6a9cf1b640de_Out_3_Vector4[0];
            float _Split_49bedf335d334a1cb82b34e3852f3369_G_2_Float = _Branch_63cecadb5ea441b9ac9f6a9cf1b640de_Out_3_Vector4[1];
            float _Split_49bedf335d334a1cb82b34e3852f3369_B_3_Float = _Branch_63cecadb5ea441b9ac9f6a9cf1b640de_Out_3_Vector4[2];
            float _Split_49bedf335d334a1cb82b34e3852f3369_A_4_Float = _Branch_63cecadb5ea441b9ac9f6a9cf1b640de_Out_3_Vector4[3];
            #endif
            surface.Alpha = _Split_49bedf335d334a1cb82b34e3852f3369_A_4_Float;
            surface.AlphaClipThreshold = float(0.5);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =                          input.normalOS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =                        input.positionOS;
        #endif
        
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 = input.texCoord0;
        #endif
        
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "Sprite Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }
        
        // Render State
        Cull Off
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma exclude_renderers d3d11_9x
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma shader_feature_local _ CORNERS_ON
        
        #if defined(CORNERS_ON)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif
        
        
        // Defines
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_COLOR
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_POSITION_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_COLOR
        #endif
        
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SPRITEFORWARD
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 color : COLOR;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 color;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 TangentSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv0;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord0 : INTERP0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 color : INTERP1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionWS : INTERP2;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.color.xyzw = input.color;
            output.positionWS.xyz = input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.color = input.color.xyzw;
            output.positionWS = input.positionWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _MainTex_TexelSize;
        float _OutlineThickness;
        float4 _OutlineColor;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Comparison_GreaterOrEqual_float(float A, float B, out float Out)
        {
            Out = A >= B ? 1 : 0;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
        Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        struct Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float
        {
        half4 uv0;
        };
        
        void SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(UnityTexture2D _Texture, float _OutlineThickness, float2 _Direction, Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float IN, out float Alpha_2)
        {
        UnityTexture2D _Property_abbd8b98b7ae46a7a589002ac361020f_Out_0_Texture2D = _Texture;
        float4 _UV_28706884e92b49018cd93fc942406a75_Out_0_Vector4 = IN.uv0;
        UnityTexture2D _Property_75130dae886e4ba88386713011b81ac6_Out_0_Texture2D = _Texture;
        float _TextureSize_387b805f38414b1baee12c937d38b1c0_Width_0_Float = _Property_75130dae886e4ba88386713011b81ac6_Out_0_Texture2D.texelSize.z;
        float _TextureSize_387b805f38414b1baee12c937d38b1c0_Height_2_Float = _Property_75130dae886e4ba88386713011b81ac6_Out_0_Texture2D.texelSize.w;
        float _TextureSize_387b805f38414b1baee12c937d38b1c0_TexelWidth_3_Float = _Property_75130dae886e4ba88386713011b81ac6_Out_0_Texture2D.texelSize.x;
        float _TextureSize_387b805f38414b1baee12c937d38b1c0_TexelHeight_4_Float = _Property_75130dae886e4ba88386713011b81ac6_Out_0_Texture2D.texelSize.y;
        float2 _Vector2_6eddb764a241497e9427406cae4687a4_Out_0_Vector2 = float2(_TextureSize_387b805f38414b1baee12c937d38b1c0_TexelWidth_3_Float, _TextureSize_387b805f38414b1baee12c937d38b1c0_TexelHeight_4_Float);
        float _Property_2fe213d5a4df4752815fa1d9c39276b5_Out_0_Float = _OutlineThickness;
        float2 _Multiply_873730e798d1451e893758a79882ee2b_Out_2_Vector2;
        Unity_Multiply_float2_float2(_Vector2_6eddb764a241497e9427406cae4687a4_Out_0_Vector2, (_Property_2fe213d5a4df4752815fa1d9c39276b5_Out_0_Float.xx), _Multiply_873730e798d1451e893758a79882ee2b_Out_2_Vector2);
        float2 _Property_e60d2a2ec0b54194af044138b75995ba_Out_0_Vector2 = _Direction;
        float2 _Multiply_e4de5667f8654b52a08221801a0ada79_Out_2_Vector2;
        Unity_Multiply_float2_float2(_Multiply_873730e798d1451e893758a79882ee2b_Out_2_Vector2, _Property_e60d2a2ec0b54194af044138b75995ba_Out_0_Vector2, _Multiply_e4de5667f8654b52a08221801a0ada79_Out_2_Vector2);
        float2 _Add_ddce0338db784adda4e04a8f39383f1a_Out_2_Vector2;
        Unity_Add_float2((_UV_28706884e92b49018cd93fc942406a75_Out_0_Vector4.xy), _Multiply_e4de5667f8654b52a08221801a0ada79_Out_2_Vector2, _Add_ddce0338db784adda4e04a8f39383f1a_Out_2_Vector2);
        float4 _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_abbd8b98b7ae46a7a589002ac361020f_Out_0_Texture2D.tex, _Property_abbd8b98b7ae46a7a589002ac361020f_Out_0_Texture2D.samplerstate, _Property_abbd8b98b7ae46a7a589002ac361020f_Out_0_Texture2D.GetTransformedUV(_Add_ddce0338db784adda4e04a8f39383f1a_Out_2_Vector2) );
        float _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_R_4_Float = _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_RGBA_0_Vector4.r;
        float _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_G_5_Float = _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_RGBA_0_Vector4.g;
        float _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_B_6_Float = _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_RGBA_0_Vector4.b;
        float _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_A_7_Float = _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_RGBA_0_Vector4.a;
        Alpha_2 = _SampleTexture2D_7b056dcfb39c46d698a0080f481927b1_A_7_Float;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float3 NormalTS;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_ae7bc432e6554c6b9ada42828bd9712d_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_985107d90cd443538ea364d660394913_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_ae7bc432e6554c6b9ada42828bd9712d_Out_0_Texture2D.tex, _Property_ae7bc432e6554c6b9ada42828bd9712d_Out_0_Texture2D.samplerstate, _Property_ae7bc432e6554c6b9ada42828bd9712d_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_985107d90cd443538ea364d660394913_R_4_Float = _SampleTexture2D_985107d90cd443538ea364d660394913_RGBA_0_Vector4.r;
            float _SampleTexture2D_985107d90cd443538ea364d660394913_G_5_Float = _SampleTexture2D_985107d90cd443538ea364d660394913_RGBA_0_Vector4.g;
            float _SampleTexture2D_985107d90cd443538ea364d660394913_B_6_Float = _SampleTexture2D_985107d90cd443538ea364d660394913_RGBA_0_Vector4.b;
            float _SampleTexture2D_985107d90cd443538ea364d660394913_A_7_Float = _SampleTexture2D_985107d90cd443538ea364d660394913_RGBA_0_Vector4.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Comparison_e435bc378d3e4dd781d438db02afa7cd_Out_2_Boolean;
            Unity_Comparison_GreaterOrEqual_float(_SampleTexture2D_985107d90cd443538ea364d660394913_A_7_Float, float(0.5), _Comparison_e435bc378d3e4dd781d438db02afa7cd_Out_2_Boolean);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_1e1702f4410e419490c825d0b35b2ead_Out_0_Vector4 = _OutlineColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_f06673bffc9f46cbaa5fdd8c56864327_R_1_Float = _Property_1e1702f4410e419490c825d0b35b2ead_Out_0_Vector4[0];
            float _Split_f06673bffc9f46cbaa5fdd8c56864327_G_2_Float = _Property_1e1702f4410e419490c825d0b35b2ead_Out_0_Vector4[1];
            float _Split_f06673bffc9f46cbaa5fdd8c56864327_B_3_Float = _Property_1e1702f4410e419490c825d0b35b2ead_Out_0_Vector4[2];
            float _Split_f06673bffc9f46cbaa5fdd8c56864327_A_4_Float = _Property_1e1702f4410e419490c825d0b35b2ead_Out_0_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_964062ebd2844318aaecce85d6407a73_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_a133e66273464419b8db283e3765d4a7_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_633e5b476f8a4f218e23b95ba1f10631;
            _OutlineSample_633e5b476f8a4f218e23b95ba1f10631.uv0 = IN.uv0;
            float _OutlineSample_633e5b476f8a4f218e23b95ba1f10631_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_964062ebd2844318aaecce85d6407a73_Out_0_Texture2D, _Property_a133e66273464419b8db283e3765d4a7_Out_0_Float, float2 (0, 1), _OutlineSample_633e5b476f8a4f218e23b95ba1f10631, _OutlineSample_633e5b476f8a4f218e23b95ba1f10631_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_d4732c6ac0ff4639b977cd09e6e705f6_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_e56d429a0d0a495db62b274d66870c4f_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_e9f656b9de294a17b3d5356b065c58f6;
            _OutlineSample_e9f656b9de294a17b3d5356b065c58f6.uv0 = IN.uv0;
            float _OutlineSample_e9f656b9de294a17b3d5356b065c58f6_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_d4732c6ac0ff4639b977cd09e6e705f6_Out_0_Texture2D, _Property_e56d429a0d0a495db62b274d66870c4f_Out_0_Float, float2 (0, -1), _OutlineSample_e9f656b9de294a17b3d5356b065c58f6, _OutlineSample_e9f656b9de294a17b3d5356b065c58f6_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_d7e78149c8da45d3a7a02885fb98d460_Out_2_Float;
            Unity_Add_float(_OutlineSample_633e5b476f8a4f218e23b95ba1f10631_Alpha_2_Float, _OutlineSample_e9f656b9de294a17b3d5356b065c58f6_Alpha_2_Float, _Add_d7e78149c8da45d3a7a02885fb98d460_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_281f7c4bce524bcdbb70b150cae0c970_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c6e1bc5d4dfe4fd1bad155365b74efc6_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_18a5cf1bff254092945f540376ef9b6c;
            _OutlineSample_18a5cf1bff254092945f540376ef9b6c.uv0 = IN.uv0;
            float _OutlineSample_18a5cf1bff254092945f540376ef9b6c_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_281f7c4bce524bcdbb70b150cae0c970_Out_0_Texture2D, _Property_c6e1bc5d4dfe4fd1bad155365b74efc6_Out_0_Float, float2 (1, 0), _OutlineSample_18a5cf1bff254092945f540376ef9b6c, _OutlineSample_18a5cf1bff254092945f540376ef9b6c_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_9ecb0ebafaa549d9b79b434435c20a6d_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_2fe114e1f7b6491288e88641a9bba1bf_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_fcbceaaf44a24210a84eee50850f03ec;
            _OutlineSample_fcbceaaf44a24210a84eee50850f03ec.uv0 = IN.uv0;
            float _OutlineSample_fcbceaaf44a24210a84eee50850f03ec_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_9ecb0ebafaa549d9b79b434435c20a6d_Out_0_Texture2D, _Property_2fe114e1f7b6491288e88641a9bba1bf_Out_0_Float, float2 (-1, 0), _OutlineSample_fcbceaaf44a24210a84eee50850f03ec, _OutlineSample_fcbceaaf44a24210a84eee50850f03ec_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_5381fd9c506b4ca1a0291df308debe92_Out_2_Float;
            Unity_Add_float(_OutlineSample_18a5cf1bff254092945f540376ef9b6c_Alpha_2_Float, _OutlineSample_fcbceaaf44a24210a84eee50850f03ec_Alpha_2_Float, _Add_5381fd9c506b4ca1a0291df308debe92_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_b1ef2c0c829f4c26a83ce17cc4415c6a_Out_2_Float;
            Unity_Add_float(_Add_d7e78149c8da45d3a7a02885fb98d460_Out_2_Float, _Add_5381fd9c506b4ca1a0291df308debe92_Out_2_Float, _Add_b1ef2c0c829f4c26a83ce17cc4415c6a_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_2775daa09b2840a692ff855a089d7ed1_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_a92ba799a89b44a6b9d949e33b41b045_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_a8a9a2a5b7354757a799e24f7ec630fc;
            _OutlineSample_a8a9a2a5b7354757a799e24f7ec630fc.uv0 = IN.uv0;
            float _OutlineSample_a8a9a2a5b7354757a799e24f7ec630fc_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_2775daa09b2840a692ff855a089d7ed1_Out_0_Texture2D, _Property_a92ba799a89b44a6b9d949e33b41b045_Out_0_Float, float2 (1, 1), _OutlineSample_a8a9a2a5b7354757a799e24f7ec630fc, _OutlineSample_a8a9a2a5b7354757a799e24f7ec630fc_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_99d859eee51b4036aee6d1e5cfbaf10b_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_a22cf2eeaa9b4cb8a65805cdd1d67f6c_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_bffe40f53e164140859914e99ab4a868;
            _OutlineSample_bffe40f53e164140859914e99ab4a868.uv0 = IN.uv0;
            float _OutlineSample_bffe40f53e164140859914e99ab4a868_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_99d859eee51b4036aee6d1e5cfbaf10b_Out_0_Texture2D, _Property_a22cf2eeaa9b4cb8a65805cdd1d67f6c_Out_0_Float, float2 (1, -1), _OutlineSample_bffe40f53e164140859914e99ab4a868, _OutlineSample_bffe40f53e164140859914e99ab4a868_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_9427078aaf0f459facc4660a16a48556_Out_2_Float;
            Unity_Add_float(_OutlineSample_a8a9a2a5b7354757a799e24f7ec630fc_Alpha_2_Float, _OutlineSample_bffe40f53e164140859914e99ab4a868_Alpha_2_Float, _Add_9427078aaf0f459facc4660a16a48556_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_efc8822385f042ce854597cbe6b9f331_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_17376dcd71f94a6d81dd2d819b617170_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_3faf78ef578d41b29338cc9138295682;
            _OutlineSample_3faf78ef578d41b29338cc9138295682.uv0 = IN.uv0;
            float _OutlineSample_3faf78ef578d41b29338cc9138295682_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_efc8822385f042ce854597cbe6b9f331_Out_0_Texture2D, _Property_17376dcd71f94a6d81dd2d819b617170_Out_0_Float, float2 (-1, 1), _OutlineSample_3faf78ef578d41b29338cc9138295682, _OutlineSample_3faf78ef578d41b29338cc9138295682_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_6e55c2f24312490e864ef82109702510_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_d351e64657ba42e3b753a1ff82e10dd3_Out_0_Float = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_OutlineSample_2313c794954e6b948bbc755bf914c870_float _OutlineSample_ff2e9dbf576f411da5b766134177ce6b;
            _OutlineSample_ff2e9dbf576f411da5b766134177ce6b.uv0 = IN.uv0;
            float _OutlineSample_ff2e9dbf576f411da5b766134177ce6b_Alpha_2_Float;
            SG_OutlineSample_2313c794954e6b948bbc755bf914c870_float(_Property_6e55c2f24312490e864ef82109702510_Out_0_Texture2D, _Property_d351e64657ba42e3b753a1ff82e10dd3_Out_0_Float, float2 (-1, -1), _OutlineSample_ff2e9dbf576f411da5b766134177ce6b, _OutlineSample_ff2e9dbf576f411da5b766134177ce6b_Alpha_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_ed80becf447e45a29d6fd66963e31215_Out_2_Float;
            Unity_Add_float(_OutlineSample_3faf78ef578d41b29338cc9138295682_Alpha_2_Float, _OutlineSample_ff2e9dbf576f411da5b766134177ce6b_Alpha_2_Float, _Add_ed80becf447e45a29d6fd66963e31215_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_7ee20d132d374beea5660578ced0497b_Out_2_Float;
            Unity_Add_float(_Add_9427078aaf0f459facc4660a16a48556_Out_2_Float, _Add_ed80becf447e45a29d6fd66963e31215_Out_2_Float, _Add_7ee20d132d374beea5660578ced0497b_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            #if defined(CORNERS_ON)
            float _SampleCorners_3f34c98769e446ecba0e17c233b75920_Out_0_Float = _Add_7ee20d132d374beea5660578ced0497b_Out_2_Float;
            #else
            float _SampleCorners_3f34c98769e446ecba0e17c233b75920_Out_0_Float = float(0);
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_8d965d46296e46959bf62a4db31f5106_Out_2_Float;
            Unity_Add_float(_Add_b1ef2c0c829f4c26a83ce17cc4415c6a_Out_2_Float, _SampleCorners_3f34c98769e446ecba0e17c233b75920_Out_0_Float, _Add_8d965d46296e46959bf62a4db31f5106_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_176fa52fcb424f33b65b05899e55d952_Out_1_Float;
            Unity_Saturate_float(_Add_8d965d46296e46959bf62a4db31f5106_Out_2_Float, _Saturate_176fa52fcb424f33b65b05899e55d952_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Vector4_65dc117aa1d74f598a28966042ced96b_Out_0_Vector4 = float4(_Split_f06673bffc9f46cbaa5fdd8c56864327_R_1_Float, _Split_f06673bffc9f46cbaa5fdd8c56864327_G_2_Float, _Split_f06673bffc9f46cbaa5fdd8c56864327_B_3_Float, _Saturate_176fa52fcb424f33b65b05899e55d952_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Branch_63cecadb5ea441b9ac9f6a9cf1b640de_Out_3_Vector4;
            Unity_Branch_float4(_Comparison_e435bc378d3e4dd781d438db02afa7cd_Out_2_Boolean, _SampleTexture2D_985107d90cd443538ea364d660394913_RGBA_0_Vector4, _Vector4_65dc117aa1d74f598a28966042ced96b_Out_0_Vector4, _Branch_63cecadb5ea441b9ac9f6a9cf1b640de_Out_3_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_49bedf335d334a1cb82b34e3852f3369_R_1_Float = _Branch_63cecadb5ea441b9ac9f6a9cf1b640de_Out_3_Vector4[0];
            float _Split_49bedf335d334a1cb82b34e3852f3369_G_2_Float = _Branch_63cecadb5ea441b9ac9f6a9cf1b640de_Out_3_Vector4[1];
            float _Split_49bedf335d334a1cb82b34e3852f3369_B_3_Float = _Branch_63cecadb5ea441b9ac9f6a9cf1b640de_Out_3_Vector4[2];
            float _Split_49bedf335d334a1cb82b34e3852f3369_A_4_Float = _Branch_63cecadb5ea441b9ac9f6a9cf1b640de_Out_3_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Combine_f0c33f58b1c84eb28a02c6cc94112b45_RGBA_4_Vector4;
            float3 _Combine_f0c33f58b1c84eb28a02c6cc94112b45_RGB_5_Vector3;
            float2 _Combine_f0c33f58b1c84eb28a02c6cc94112b45_RG_6_Vector2;
            Unity_Combine_float(_Split_49bedf335d334a1cb82b34e3852f3369_R_1_Float, _Split_49bedf335d334a1cb82b34e3852f3369_G_2_Float, _Split_49bedf335d334a1cb82b34e3852f3369_B_3_Float, float(0), _Combine_f0c33f58b1c84eb28a02c6cc94112b45_RGBA_4_Vector4, _Combine_f0c33f58b1c84eb28a02c6cc94112b45_RGB_5_Vector3, _Combine_f0c33f58b1c84eb28a02c6cc94112b45_RG_6_Vector2);
            #endif
            surface.BaseColor = _Combine_f0c33f58b1c84eb28a02c6cc94112b45_RGB_5_Vector3;
            surface.Alpha = _Split_49bedf335d334a1cb82b34e3852f3369_A_4_Float;
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.AlphaClipThreshold = float(0.5);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =                          input.normalOS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =                        input.positionOS;
        #endif
        
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        #endif
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 = input.texCoord0;
        #endif
        
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/2D/ShaderGraph/Includes/SpriteForwardPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
    }
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    FallBack "Hidden/Shader Graph/FallbackError"
}