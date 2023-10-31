module Bertie.Tls13crypto
#set-options "--fuel 0 --ifuel 1 --z3rlimit 15"
open Core

let t_Random = Bertie.Tls13utils.t_Bytes

let t_Entropy = Bertie.Tls13utils.t_Bytes

let t_SignatureKey = Bertie.Tls13utils.t_Bytes

let t_PSK = Bertie.Tls13utils.t_Bytes

let t_Key = Bertie.Tls13utils.t_Bytes

let t_MacKey = Bertie.Tls13utils.t_Bytes

let t_KemPk = Bertie.Tls13utils.t_Bytes

let t_KemSk = Bertie.Tls13utils.t_Bytes

let t_HMAC = Bertie.Tls13utils.t_Bytes

let t_Digest = Bertie.Tls13utils.t_Bytes

let t_AeadKey = Bertie.Tls13utils.t_Bytes

let t_AeadIV = Bertie.Tls13utils.t_Bytes

let t_AeadKeyIV = (Bertie.Tls13utils.t_Bytes & Bertie.Tls13utils.t_Bytes)

type t_HashAlgorithm =
  | HashAlgorithm_SHA256 : t_HashAlgorithm
  | HashAlgorithm_SHA384 : t_HashAlgorithm
  | HashAlgorithm_SHA512 : t_HashAlgorithm

let to_libcrux_hash_alg (alg: t_HashAlgorithm) : Core.Result.t_Result Libcrux.Digest.t_Algorithm u8 =
  match alg with
  | HashAlgorithm_SHA256  -> Core.Result.Result_Ok Libcrux.Digest.Algorithm_Sha256
  | HashAlgorithm_SHA384  -> Core.Result.Result_Ok Libcrux.Digest.Algorithm_Sha384
  | HashAlgorithm_SHA512  -> Core.Result.Result_Ok Libcrux.Digest.Algorithm_Sha512

let hash (alg: t_HashAlgorithm) (data: Bertie.Tls13utils.t_Bytes)
    : Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8 =
  Rust_primitives.Hax.Control_flow_monad.Mexception.run (let* hoist418:Libcrux.Digest.t_Algorithm =
        match
          Core.Ops.Try_trait.f_branch (to_libcrux_hash_alg alg
              <:
              Core.Result.t_Result Libcrux.Digest.t_Algorithm u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist417:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist417)
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
      in
      Core.Ops.Control_flow.ControlFlow_Continue
      (let hoist419:Alloc.Vec.t_Vec u8 Alloc.Alloc.t_Global =
          Libcrux.Digest.hash hoist418
            (Core.Ops.Deref.f_deref (Bertie.Tls13utils.f_declassify data
                  <:
                  Alloc.Vec.t_Vec u8 Alloc.Alloc.t_Global)
              <:
              t_Slice u8)
        in
        let hoist420:Bertie.Tls13utils.t_Bytes = Core.Convert.f_into hoist419 in
        Core.Result.Result_Ok hoist420))

let hash_len (alg: t_HashAlgorithm) : usize =
  match alg with
  | HashAlgorithm_SHA256  -> Libcrux.Digest.digest_size Libcrux.Digest.Algorithm_Sha256
  | HashAlgorithm_SHA384  -> Libcrux.Digest.digest_size Libcrux.Digest.Algorithm_Sha384
  | HashAlgorithm_SHA512  -> Libcrux.Digest.digest_size Libcrux.Digest.Algorithm_Sha512

let to_libcrux_hmac_alg (alg: t_HashAlgorithm) : Core.Result.t_Result Libcrux.Hmac.t_Algorithm u8 =
  match alg with
  | HashAlgorithm_SHA256  -> Core.Result.Result_Ok Libcrux.Hmac.Algorithm_Sha256
  | HashAlgorithm_SHA384  -> Core.Result.Result_Ok Libcrux.Hmac.Algorithm_Sha384
  | HashAlgorithm_SHA512  -> Core.Result.Result_Ok Libcrux.Hmac.Algorithm_Sha512

let hmac_tag_len (alg: t_HashAlgorithm) : usize = hash_len alg

let hmac_tag (alg: t_HashAlgorithm) (mk input: Bertie.Tls13utils.t_Bytes)
    : Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8 =
  Rust_primitives.Hax.Control_flow_monad.Mexception.run (let* hoist422:Libcrux.Hmac.t_Algorithm =
        match
          Core.Ops.Try_trait.f_branch (to_libcrux_hmac_alg alg
              <:
              Core.Result.t_Result Libcrux.Hmac.t_Algorithm u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist421:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist421)
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
      in
      Core.Ops.Control_flow.ControlFlow_Continue
      (let hoist423:Alloc.Vec.t_Vec u8 Alloc.Alloc.t_Global =
          Libcrux.Hmac.hmac hoist422
            (Core.Ops.Deref.f_deref (Bertie.Tls13utils.f_declassify mk
                  <:
                  Alloc.Vec.t_Vec u8 Alloc.Alloc.t_Global)
              <:
              t_Slice u8)
            (Core.Ops.Deref.f_deref (Bertie.Tls13utils.f_declassify input
                  <:
                  Alloc.Vec.t_Vec u8 Alloc.Alloc.t_Global)
              <:
              t_Slice u8)
            Core.Option.Option_None
        in
        let hoist424:Bertie.Tls13utils.t_Bytes = Core.Convert.f_into hoist423 in
        Core.Result.Result_Ok hoist424))

let hmac_verify (alg: t_HashAlgorithm) (mk input tag: Bertie.Tls13utils.t_Bytes)
    : Core.Result.t_Result Prims.unit u8 =
  Rust_primitives.Hax.Control_flow_monad.Mexception.run (let* hoist426:Bertie.Tls13utils.t_Bytes =
        match
          Core.Ops.Try_trait.f_branch (hmac_tag alg mk input
              <:
              Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist425:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result Prims.unit u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist425)
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
      in
      Core.Ops.Control_flow.ControlFlow_Continue
      (let hoist427:bool = Bertie.Tls13utils.eq hoist426 tag in
        if hoist427
        then Core.Result.Result_Ok ()
        else Bertie.Tls13utils.tlserr Bertie.Tls13utils.v_CRYPTO_ERROR))

let zero_key (alg: t_HashAlgorithm) : Bertie.Tls13utils.t_Bytes =
  Bertie.Tls13utils.impl__Bytes__zeroes (hash_len alg <: usize)

let to_libcrux_hkdf_alg (alg: t_HashAlgorithm) : Core.Result.t_Result Libcrux.Hkdf.t_Algorithm u8 =
  match alg with
  | HashAlgorithm_SHA256  -> Core.Result.Result_Ok Libcrux.Hkdf.Algorithm_Sha256
  | HashAlgorithm_SHA384  -> Core.Result.Result_Ok Libcrux.Hkdf.Algorithm_Sha384
  | HashAlgorithm_SHA512  -> Core.Result.Result_Ok Libcrux.Hkdf.Algorithm_Sha512

let hkdf_extract (alg: t_HashAlgorithm) (salt ikm: Bertie.Tls13utils.t_Bytes)
    : Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8 =
  Rust_primitives.Hax.Control_flow_monad.Mexception.run (let* hoist429:Libcrux.Hkdf.t_Algorithm =
        match
          Core.Ops.Try_trait.f_branch (to_libcrux_hkdf_alg alg
              <:
              Core.Result.t_Result Libcrux.Hkdf.t_Algorithm u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist428:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist428)
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
      in
      Core.Ops.Control_flow.ControlFlow_Continue
      (let hoist430:Alloc.Vec.t_Vec u8 Alloc.Alloc.t_Global =
          Libcrux.Hkdf.extract hoist429
            (Bertie.Tls13utils.f_declassify salt <: Alloc.Vec.t_Vec u8 Alloc.Alloc.t_Global)
            (Bertie.Tls13utils.f_declassify ikm <: Alloc.Vec.t_Vec u8 Alloc.Alloc.t_Global)
        in
        let hoist431:Bertie.Tls13utils.t_Bytes = Core.Convert.f_into hoist430 in
        Core.Result.Result_Ok hoist431))

let hkdf_expand (alg: t_HashAlgorithm) (prk info: Bertie.Tls13utils.t_Bytes) (len: usize)
    : Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8 =
  Rust_primitives.Hax.Control_flow_monad.Mexception.run (let* hoist433:Libcrux.Hkdf.t_Algorithm =
        match
          Core.Ops.Try_trait.f_branch (to_libcrux_hkdf_alg alg
              <:
              Core.Result.t_Result Libcrux.Hkdf.t_Algorithm u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist432:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist432)
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
      in
      Core.Ops.Control_flow.ControlFlow_Continue
      (let hoist434:Core.Result.t_Result (Alloc.Vec.t_Vec u8 Alloc.Alloc.t_Global)
          Libcrux.Hkdf.t_Error =
          Libcrux.Hkdf.expand hoist433
            (Bertie.Tls13utils.f_declassify prk <: Alloc.Vec.t_Vec u8 Alloc.Alloc.t_Global)
            (Bertie.Tls13utils.f_declassify info <: Alloc.Vec.t_Vec u8 Alloc.Alloc.t_Global)
            len
        in
        match hoist434 with
        | Core.Result.Result_Ok x -> Core.Result.Result_Ok (Core.Convert.f_into x)
        | Core.Result.Result_Err _ -> Bertie.Tls13utils.tlserr Bertie.Tls13utils.v_CRYPTO_ERROR))

type t_AeadAlgorithm =
  | AeadAlgorithm_Chacha20Poly1305 : t_AeadAlgorithm
  | AeadAlgorithm_Aes128Gcm : t_AeadAlgorithm
  | AeadAlgorithm_Aes256Gcm : t_AeadAlgorithm

let to_libcrux_aead_alg (alg: t_AeadAlgorithm) : Core.Result.t_Result Libcrux.Aead.t_Algorithm u8 =
  match alg with
  | AeadAlgorithm_Chacha20Poly1305  -> Core.Result.Result_Ok Libcrux.Aead.Algorithm_Chacha20Poly1305
  | AeadAlgorithm_Aes128Gcm  -> Core.Result.Result_Ok Libcrux.Aead.Algorithm_Aes128Gcm
  | AeadAlgorithm_Aes256Gcm  -> Core.Result.Result_Ok Libcrux.Aead.Algorithm_Aes256Gcm

let ae_key_len (alg: t_AeadAlgorithm) : usize =
  match alg with
  | AeadAlgorithm_Chacha20Poly1305  -> sz 32
  | AeadAlgorithm_Aes128Gcm  -> sz 16
  | AeadAlgorithm_Aes256Gcm  -> sz 32

let ae_key_wrap (alg: t_AeadAlgorithm) (k: Bertie.Tls13utils.t_Bytes)
    : Core.Result.t_Result Libcrux.Aead.t_Key u8 =
  Rust_primitives.Hax.Control_flow_monad.Mexception.run (match alg with
      | AeadAlgorithm_Chacha20Poly1305  ->
        let* hoist436:t_Array u8 (sz 32) =
          match
            Core.Ops.Try_trait.f_branch (Bertie.Tls13utils.impl__Bytes__declassify_array k
                <:
                Core.Result.t_Result (t_Array u8 (sz 32)) u8)
          with
          | Core.Ops.Control_flow.ControlFlow_Break residual ->
            let* hoist435:Rust_primitives.Hax.t_Never =
              Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                  <:
                  Core.Result.t_Result Libcrux.Aead.t_Key u8)
            in
            Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist435)
          | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
            Core.Ops.Control_flow.ControlFlow_Continue v_val
        in
        Core.Ops.Control_flow.ControlFlow_Continue
        (let hoist437:Libcrux.Aead.t_Chacha20Key = Libcrux.Aead.Chacha20Key hoist436 in
          let hoist438:Libcrux.Aead.t_Key = Libcrux.Aead.Key_Chacha20Poly1305 hoist437 in
          Core.Result.Result_Ok hoist438)
      | AeadAlgorithm_Aes128Gcm  ->
        let* hoist440:t_Array u8 (sz 16) =
          match
            Core.Ops.Try_trait.f_branch (Bertie.Tls13utils.impl__Bytes__declassify_array k
                <:
                Core.Result.t_Result (t_Array u8 (sz 16)) u8)
          with
          | Core.Ops.Control_flow.ControlFlow_Break residual ->
            let* hoist439:Rust_primitives.Hax.t_Never =
              Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                  <:
                  Core.Result.t_Result Libcrux.Aead.t_Key u8)
            in
            Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist439)
          | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
            Core.Ops.Control_flow.ControlFlow_Continue v_val
        in
        Core.Ops.Control_flow.ControlFlow_Continue
        (let hoist441:Libcrux.Aead.t_Aes128Key = Libcrux.Aead.Aes128Key hoist440 in
          let hoist442:Libcrux.Aead.t_Key = Libcrux.Aead.Key_Aes128 hoist441 in
          Core.Result.Result_Ok hoist442)
      | AeadAlgorithm_Aes256Gcm  ->
        let* hoist444:t_Array u8 (sz 32) =
          match
            Core.Ops.Try_trait.f_branch (Bertie.Tls13utils.impl__Bytes__declassify_array k
                <:
                Core.Result.t_Result (t_Array u8 (sz 32)) u8)
          with
          | Core.Ops.Control_flow.ControlFlow_Break residual ->
            let* hoist443:Rust_primitives.Hax.t_Never =
              Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                  <:
                  Core.Result.t_Result Libcrux.Aead.t_Key u8)
            in
            Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist443)
          | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
            Core.Ops.Control_flow.ControlFlow_Continue v_val
        in
        Core.Ops.Control_flow.ControlFlow_Continue
        (let hoist445:Libcrux.Aead.t_Aes256Key = Libcrux.Aead.Aes256Key hoist444 in
          let hoist446:Libcrux.Aead.t_Key = Libcrux.Aead.Key_Aes256 hoist445 in
          Core.Result.Result_Ok hoist446))

let ae_iv_len (alg: t_AeadAlgorithm) : usize =
  match alg with
  | AeadAlgorithm_Chacha20Poly1305  -> sz 12
  | AeadAlgorithm_Aes128Gcm  -> sz 12
  | AeadAlgorithm_Aes256Gcm  -> sz 12

let aead_encrypt (alg: t_AeadAlgorithm) (k iv plain aad: Bertie.Tls13utils.t_Bytes)
    : Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8 =
  Rust_primitives.Hax.Control_flow_monad.Mexception.run (let _:Prims.unit =
        Std.Io.Stdio.v__print (Core.Fmt.impl_2__new_v1 (Rust_primitives.unsize (let list =
                      ["enc key "; "\n nonce: "; "\n"]
                    in
                    FStar.Pervasives.assert_norm (Prims.eq2 (List.Tot.length list) 3);
                    Rust_primitives.Hax.array_of_list list)
                <:
                t_Slice string)
              (Rust_primitives.unsize (let list =
                      [
                        Core.Fmt.Rt.impl_1__new_display (Bertie.Tls13utils.impl__Bytes__to_hex k
                            <:
                            Alloc.String.t_String)
                        <:
                        Core.Fmt.Rt.t_Argument;
                        Core.Fmt.Rt.impl_1__new_display (Bertie.Tls13utils.impl__Bytes__to_hex iv
                            <:
                            Alloc.String.t_String)
                        <:
                        Core.Fmt.Rt.t_Argument
                      ]
                    in
                    FStar.Pervasives.assert_norm (Prims.eq2 (List.Tot.length list) 2);
                    Rust_primitives.Hax.array_of_list list)
                <:
                t_Slice Core.Fmt.Rt.t_Argument)
            <:
            Core.Fmt.t_Arguments)
      in
      let _:Prims.unit = () in
      let* hoist451:Libcrux.Aead.t_Key =
        match
          Core.Ops.Try_trait.f_branch (ae_key_wrap alg k
              <:
              Core.Result.t_Result Libcrux.Aead.t_Key u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist447:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist447)
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
      in
      let* hoist449:t_Array u8 (sz 12) =
        match
          Core.Ops.Try_trait.f_branch (Bertie.Tls13utils.impl__Bytes__declassify_array iv
              <:
              Core.Result.t_Result (t_Array u8 (sz 12)) u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist448:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist448)
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
      in
      Core.Ops.Control_flow.ControlFlow_Continue
      (let hoist450:Libcrux.Aead.t_Iv = Libcrux.Aead.Iv hoist449 in
        let res:Core.Result.t_Result (Libcrux.Aead.t_Tag & Alloc.Vec.t_Vec u8 Alloc.Alloc.t_Global)
          Libcrux.Aead.t_Error =
          Libcrux.Aead.encrypt_detached hoist451
            (Bertie.Tls13utils.f_declassify plain <: Alloc.Vec.t_Vec u8 Alloc.Alloc.t_Global)
            hoist450
            (Bertie.Tls13utils.f_declassify aad <: Alloc.Vec.t_Vec u8 Alloc.Alloc.t_Global)
        in
        match res with
        | Core.Result.Result_Ok (tag, cip) ->
          let (cipby: Bertie.Tls13utils.t_Bytes):Bertie.Tls13utils.t_Bytes =
            Core.Convert.f_into cip
          in
          let (tagby: Bertie.Tls13utils.t_Bytes):Bertie.Tls13utils.t_Bytes =
            Core.Convert.f_into (Core.Convert.f_as_ref tag <: t_Slice u8)
          in
          Core.Result.Result_Ok (Bertie.Tls13utils.impl__Bytes__concat cipby tagby)
        | Core.Result.Result_Err _ -> Bertie.Tls13utils.tlserr Bertie.Tls13utils.v_CRYPTO_ERROR))

let aead_decrypt (alg: t_AeadAlgorithm) (k iv cip aad: Bertie.Tls13utils.t_Bytes)
    : Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8 =
  Rust_primitives.Hax.Control_flow_monad.Mexception.run (let _:Prims.unit =
        Std.Io.Stdio.v__print (Core.Fmt.impl_2__new_v1 (Rust_primitives.unsize (let list =
                      ["dec key "; "\n nonce: "; "\n"]
                    in
                    FStar.Pervasives.assert_norm (Prims.eq2 (List.Tot.length list) 3);
                    Rust_primitives.Hax.array_of_list list)
                <:
                t_Slice string)
              (Rust_primitives.unsize (let list =
                      [
                        Core.Fmt.Rt.impl_1__new_display (Bertie.Tls13utils.impl__Bytes__to_hex k
                            <:
                            Alloc.String.t_String)
                        <:
                        Core.Fmt.Rt.t_Argument;
                        Core.Fmt.Rt.impl_1__new_display (Bertie.Tls13utils.impl__Bytes__to_hex iv
                            <:
                            Alloc.String.t_String)
                        <:
                        Core.Fmt.Rt.t_Argument
                      ]
                    in
                    FStar.Pervasives.assert_norm (Prims.eq2 (List.Tot.length list) 2);
                    Rust_primitives.Hax.array_of_list list)
                <:
                t_Slice Core.Fmt.Rt.t_Argument)
            <:
            Core.Fmt.t_Arguments)
      in
      let _:Prims.unit = () in
      let tag:Bertie.Tls13utils.t_Bytes =
        Bertie.Tls13utils.impl__Bytes__slice cip
          ((Bertie.Tls13utils.impl__Bytes__len cip <: usize) -! sz 16 <: usize)
          (sz 16)
      in
      let cip:Bertie.Tls13utils.t_Bytes =
        Bertie.Tls13utils.impl__Bytes__slice cip
          (sz 0)
          ((Bertie.Tls13utils.impl__Bytes__len cip <: usize) -! sz 16 <: usize)
      in
      let* (tag: t_Array u8 (sz 16)):t_Array u8 (sz 16) =
        match
          Core.Ops.Try_trait.f_branch (Bertie.Tls13utils.impl__Bytes__declassify_array tag
              <:
              Core.Result.t_Result (t_Array u8 (sz 16)) u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist452:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist452)
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
      in
      let* hoist457:Libcrux.Aead.t_Key =
        match
          Core.Ops.Try_trait.f_branch (ae_key_wrap alg k
              <:
              Core.Result.t_Result Libcrux.Aead.t_Key u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist453:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist453)
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
      in
      let* hoist455:t_Array u8 (sz 12) =
        match
          Core.Ops.Try_trait.f_branch (Bertie.Tls13utils.impl__Bytes__declassify_array iv
              <:
              Core.Result.t_Result (t_Array u8 (sz 12)) u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist454:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist454)
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
      in
      Core.Ops.Control_flow.ControlFlow_Continue
      (let hoist456:Libcrux.Aead.t_Iv = Libcrux.Aead.Iv hoist455 in
        let plain:Core.Result.t_Result (Alloc.Vec.t_Vec u8 Alloc.Alloc.t_Global)
          Libcrux.Aead.t_Error =
          Libcrux.Aead.decrypt_detached hoist457
            (Bertie.Tls13utils.f_declassify cip <: Alloc.Vec.t_Vec u8 Alloc.Alloc.t_Global)
            hoist456
            (Bertie.Tls13utils.f_declassify aad <: Alloc.Vec.t_Vec u8 Alloc.Alloc.t_Global)
            (Core.Convert.f_from tag <: Libcrux.Aead.t_Tag)
        in
        match plain with
        | Core.Result.Result_Ok plain -> Core.Result.Result_Ok (Core.Convert.f_into plain)
        | Core.Result.Result_Err _ -> Bertie.Tls13utils.tlserr Bertie.Tls13utils.v_CRYPTO_ERROR))

type t_SignatureScheme =
  | SignatureScheme_RsaPssRsaSha256 : t_SignatureScheme
  | SignatureScheme_EcdsaSecp256r1Sha256 : t_SignatureScheme
  | SignatureScheme_ED25519 : t_SignatureScheme

let to_libcrux_sig_alg (a: t_SignatureScheme)
    : Core.Result.t_Result Libcrux.Signature.t_Algorithm u8 =
  match a with
  | SignatureScheme_RsaPssRsaSha256  ->
    Bertie.Tls13utils.tlserr Bertie.Tls13utils.v_UNSUPPORTED_ALGORITHM
  | SignatureScheme_ED25519  -> Core.Result.Result_Ok Libcrux.Signature.Algorithm_Ed25519
  | SignatureScheme_EcdsaSecp256r1Sha256  ->
    Core.Result.Result_Ok
    (Libcrux.Signature.Algorithm_EcDsaP256 Libcrux.Signature.DigestAlgorithm_Sha256)

let sign (alg: t_SignatureScheme) (sk input ent: Bertie.Tls13utils.t_Bytes)
    : Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8 =
  Rust_primitives.Hax.Control_flow_monad.Mexception.run (let* hoist459:Libcrux.Signature.t_Algorithm
      =
        match
          Core.Ops.Try_trait.f_branch (to_libcrux_sig_alg alg
              <:
              Core.Result.t_Result Libcrux.Signature.t_Algorithm u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist458:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist458)
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
      in
      Core.Ops.Control_flow.ControlFlow_Continue
      (let _, out:(Rand.Rngs.Thread.t_ThreadRng &
          Core.Result.t_Result Libcrux.Signature.t_Signature Libcrux.Signature.t_Error) =
          Libcrux.Signature.sign hoist459
            (Core.Ops.Deref.f_deref (Bertie.Tls13utils.f_declassify input
                  <:
                  Alloc.Vec.t_Vec u8 Alloc.Alloc.t_Global)
              <:
              t_Slice u8)
            (Core.Ops.Deref.f_deref (Bertie.Tls13utils.f_declassify sk
                  <:
                  Alloc.Vec.t_Vec u8 Alloc.Alloc.t_Global)
              <:
              t_Slice u8)
            (Rand.Rngs.Thread.thread_rng <: Rand.Rngs.Thread.t_ThreadRng)
        in
        let sig:Core.Result.t_Result Libcrux.Signature.t_Signature Libcrux.Signature.t_Error =
          out
        in
        match sig with
        | Core.Result.Result_Ok (Libcrux.Signature.Signature_Ed25519 sig) ->
          Core.Result.Result_Ok
          (Core.Convert.f_into (Libcrux.Signature.impl__Ed25519Signature__as_bytes sig
                <:
                t_Array u8 (sz 64)))
        | Core.Result.Result_Ok (Libcrux.Signature.Signature_EcDsaP256 sig) ->
          let r, s:(t_Array u8 (sz 32) & t_Array u8 (sz 32)) =
            Libcrux.Signature.impl__EcDsaP256Signature__as_bytes sig
          in
          Core.Result.Result_Ok
          (Bertie.Tls13utils.impl__Bytes__concat (Core.Convert.f_from r <: Bertie.Tls13utils.t_Bytes
              )
              (Core.Convert.f_from s <: Bertie.Tls13utils.t_Bytes))
        | Core.Result.Result_Ok (Libcrux.Signature.Signature_RsaPss sig) ->
          Core.Result.Result_Ok
          (Core.Convert.f_into (Libcrux.Signature.Rsa_pss.impl__RsaPssSignature__as_bytes sig
                <:
                t_Slice u8))
        | Core.Result.Result_Err _ -> Bertie.Tls13utils.tlserr Bertie.Tls13utils.v_CRYPTO_ERROR))

let verify
      (alg: t_SignatureScheme)
      (pk: Bertie.Tls13cert.t_PublicVerificationKey)
      (input sig: Bertie.Tls13utils.t_Bytes)
    : Core.Result.t_Result Prims.unit u8 =
  Rust_primitives.Hax.Control_flow_monad.Mexception.run (match alg, pk with
      | SignatureScheme_ED25519 , Bertie.Tls13cert.PublicVerificationKey_EcDsa pk ->
        let* hoist461:t_Array u8 (sz 64) =
          match
            Core.Ops.Try_trait.f_branch (Bertie.Tls13utils.impl__Bytes__declassify_array sig
                <:
                Core.Result.t_Result (t_Array u8 (sz 64)) u8)
          with
          | Core.Ops.Control_flow.ControlFlow_Break residual ->
            let* hoist460:Rust_primitives.Hax.t_Never =
              Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                  <:
                  Core.Result.t_Result Prims.unit u8)
            in
            Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist460)
          | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
            Core.Ops.Control_flow.ControlFlow_Continue v_val
        in
        Core.Ops.Control_flow.ControlFlow_Continue
        (let hoist462:Libcrux.Signature.t_Ed25519Signature =
            Libcrux.Signature.impl__Ed25519Signature__from_bytes hoist461
          in
          let hoist463:Libcrux.Signature.t_Signature =
            Libcrux.Signature.Signature_Ed25519 hoist462
          in
          let res:Core.Result.t_Result Prims.unit Libcrux.Signature.t_Error =
            Libcrux.Signature.verify (Core.Ops.Deref.f_deref (Bertie.Tls13utils.f_declassify input
                    <:
                    Alloc.Vec.t_Vec u8 Alloc.Alloc.t_Global)
                <:
                t_Slice u8)
              hoist463
              (Core.Ops.Deref.f_deref (Bertie.Tls13utils.f_declassify pk
                    <:
                    Alloc.Vec.t_Vec u8 Alloc.Alloc.t_Global)
                <:
                t_Slice u8)
          in
          match res with
          | Core.Result.Result_Ok res -> Core.Result.Result_Ok res
          | Core.Result.Result_Err _ -> Bertie.Tls13utils.tlserr Bertie.Tls13utils.v_CRYPTO_ERROR)
      | SignatureScheme_EcdsaSecp256r1Sha256 , Bertie.Tls13cert.PublicVerificationKey_EcDsa pk ->
        let* hoist465:t_Array u8 (sz 64) =
          match
            Core.Ops.Try_trait.f_branch (Bertie.Tls13utils.impl__Bytes__declassify_array sig
                <:
                Core.Result.t_Result (t_Array u8 (sz 64)) u8)
          with
          | Core.Ops.Control_flow.ControlFlow_Break residual ->
            let* hoist464:Rust_primitives.Hax.t_Never =
              Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                  <:
                  Core.Result.t_Result Prims.unit u8)
            in
            Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist464)
          | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
            Core.Ops.Control_flow.ControlFlow_Continue v_val
        in
        Core.Ops.Control_flow.ControlFlow_Continue
        (let hoist466:Libcrux.Signature.t_EcDsaP256Signature =
            Libcrux.Signature.impl__EcDsaP256Signature__from_bytes hoist465
              (Libcrux.Signature.Algorithm_EcDsaP256 Libcrux.Signature.DigestAlgorithm_Sha256)
          in
          let hoist467:Libcrux.Signature.t_Signature =
            Libcrux.Signature.Signature_EcDsaP256 hoist466
          in
          let res:Core.Result.t_Result Prims.unit Libcrux.Signature.t_Error =
            Libcrux.Signature.verify (Core.Ops.Deref.f_deref (Bertie.Tls13utils.f_declassify input
                    <:
                    Alloc.Vec.t_Vec u8 Alloc.Alloc.t_Global)
                <:
                t_Slice u8)
              hoist467
              (Core.Ops.Deref.f_deref (Bertie.Tls13utils.f_declassify pk
                    <:
                    Alloc.Vec.t_Vec u8 Alloc.Alloc.t_Global)
                <:
                t_Slice u8)
          in
          match res with
          | Core.Result.Result_Ok res -> Core.Result.Result_Ok res
          | Core.Result.Result_Err _ -> Bertie.Tls13utils.tlserr Bertie.Tls13utils.v_CRYPTO_ERROR)
      | _ ->
        Core.Ops.Control_flow.ControlFlow_Continue
        (Bertie.Tls13utils.tlserr Bertie.Tls13utils.v_UNSUPPORTED_ALGORITHM
          <:
          Core.Result.t_Result Prims.unit u8))

type t_KemScheme =
  | KemScheme_X25519 : t_KemScheme
  | KemScheme_Secp256r1 : t_KemScheme
  | KemScheme_X448 : t_KemScheme
  | KemScheme_Secp384r1 : t_KemScheme
  | KemScheme_Secp521r1 : t_KemScheme

let kem_priv_len (alg: t_KemScheme) : usize =
  match alg with
  | KemScheme_X25519  -> sz 32
  | KemScheme_Secp256r1  -> sz 32
  | _ -> sz 64

let to_libcrux_kem_alg (alg: t_KemScheme) : Core.Result.t_Result Libcrux.Kem.t_Algorithm u8 =
  match alg with
  | KemScheme_X25519  -> Core.Result.Result_Ok Libcrux.Kem.Algorithm_X25519
  | KemScheme_Secp256r1  -> Core.Result.Result_Ok Libcrux.Kem.Algorithm_Secp256r1
  | _ -> Bertie.Tls13utils.tlserr Bertie.Tls13utils.v_UNSUPPORTED_ALGORITHM

let kem_keygen (alg: t_KemScheme) (ent: Bertie.Tls13utils.t_Bytes)
    : Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & Bertie.Tls13utils.t_Bytes) u8 =
  Rust_primitives.Hax.Control_flow_monad.Mexception.run (let* hoist469:Libcrux.Kem.t_Algorithm =
        match
          Core.Ops.Try_trait.f_branch (to_libcrux_kem_alg alg
              <:
              Core.Result.t_Result Libcrux.Kem.t_Algorithm u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist468:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & Bertie.Tls13utils.t_Bytes) u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist468)
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
      in
      Core.Ops.Control_flow.ControlFlow_Continue
      (let _, out:(Rand.Rngs.Thread.t_ThreadRng &
          Core.Result.t_Result (Libcrux.Kem.t_PrivateKey & Libcrux.Kem.t_PublicKey)
            Libcrux.Kem.t_Error) =
          Libcrux.Kem.key_gen hoist469 (Rand.Rngs.Thread.thread_rng <: Rand.Rngs.Thread.t_ThreadRng)
        in
        let res:Core.Result.t_Result (Libcrux.Kem.t_PrivateKey & Libcrux.Kem.t_PublicKey)
          Libcrux.Kem.t_Error =
          out
        in
        match res with
        | Core.Result.Result_Ok (sk, pk) ->
          Core.Result.Result_Ok
          (Core.Convert.f_from (Libcrux.Kem.impl__PrivateKey__encode sk
                <:
                Alloc.Vec.t_Vec u8 Alloc.Alloc.t_Global),
            Core.Convert.f_from (Libcrux.Kem.impl__PublicKey__encode pk
                <:
                Alloc.Vec.t_Vec u8 Alloc.Alloc.t_Global))
        | Core.Result.Result_Err _ -> Bertie.Tls13utils.tlserr Bertie.Tls13utils.v_CRYPTO_ERROR))

let kem_encap (alg: t_KemScheme) (pk ent: Bertie.Tls13utils.t_Bytes)
    : Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & Bertie.Tls13utils.t_Bytes) u8 =
  Rust_primitives.Hax.Control_flow_monad.Mexception.run (let* hoist471:Libcrux.Kem.t_Algorithm =
        match
          Core.Ops.Try_trait.f_branch (to_libcrux_kem_alg alg
              <:
              Core.Result.t_Result Libcrux.Kem.t_Algorithm u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist470:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & Bertie.Tls13utils.t_Bytes) u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist470)
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
      in
      Core.Ops.Control_flow.ControlFlow_Continue
      (let hoist472:Core.Result.t_Result Libcrux.Kem.t_PublicKey Libcrux.Kem.t_Error =
          Libcrux.Kem.impl__PublicKey__decode hoist471
            (Core.Ops.Deref.f_deref (Bertie.Tls13utils.f_declassify pk
                  <:
                  Alloc.Vec.t_Vec u8 Alloc.Alloc.t_Global)
              <:
              t_Slice u8)
        in
        let pk:Libcrux.Kem.t_PublicKey = Core.Result.impl__unwrap hoist472 in
        let _, out:(Rand.Rngs.Thread.t_ThreadRng &
          Core.Result.t_Result (Libcrux.Kem.t_Ss & Libcrux.Kem.t_Ct) Libcrux.Kem.t_Error) =
          Libcrux.Kem.encapsulate pk (Rand.Rngs.Thread.thread_rng <: Rand.Rngs.Thread.t_ThreadRng)
        in
        let res:Core.Result.t_Result (Libcrux.Kem.t_Ss & Libcrux.Kem.t_Ct) Libcrux.Kem.t_Error =
          out
        in
        match res with
        | Core.Result.Result_Ok (gxy, gy) ->
          Core.Result.Result_Ok
          (Core.Convert.f_from (Libcrux.Kem.impl__Ss__encode gxy
                <:
                Alloc.Vec.t_Vec u8 Alloc.Alloc.t_Global),
            Core.Convert.f_from (Libcrux.Kem.impl__Ct__encode gy
                <:
                Alloc.Vec.t_Vec u8 Alloc.Alloc.t_Global))
        | Core.Result.Result_Err _ -> Bertie.Tls13utils.tlserr Bertie.Tls13utils.v_CRYPTO_ERROR))

let kem_decap (alg: t_KemScheme) (ct sk: Bertie.Tls13utils.t_Bytes)
    : Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8 =
  Rust_primitives.Hax.Control_flow_monad.Mexception.run (let* alg:Libcrux.Kem.t_Algorithm =
        match
          Core.Ops.Try_trait.f_branch (to_libcrux_kem_alg alg
              <:
              Core.Result.t_Result Libcrux.Kem.t_Algorithm u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist473:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist473)
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
      in
      Core.Ops.Control_flow.ControlFlow_Continue
      (let sk:Libcrux.Kem.t_PrivateKey =
          Core.Result.impl__unwrap (Libcrux.Kem.impl__PrivateKey__decode alg
                (Core.Ops.Deref.f_deref (Bertie.Tls13utils.f_declassify sk
                      <:
                      Alloc.Vec.t_Vec u8 Alloc.Alloc.t_Global)
                  <:
                  t_Slice u8)
              <:
              Core.Result.t_Result Libcrux.Kem.t_PrivateKey Libcrux.Kem.t_Error)
        in
        let ct:Libcrux.Kem.t_Ct =
          Core.Result.impl__unwrap (Libcrux.Kem.impl__Ct__decode alg
                (Core.Ops.Deref.f_deref (Bertie.Tls13utils.f_declassify ct
                      <:
                      Alloc.Vec.t_Vec u8 Alloc.Alloc.t_Global)
                  <:
                  t_Slice u8)
              <:
              Core.Result.t_Result Libcrux.Kem.t_Ct Libcrux.Kem.t_Error)
        in
        let res:Core.Result.t_Result Libcrux.Kem.t_Ss Libcrux.Kem.t_Error =
          Libcrux.Kem.decapsulate ct sk
        in
        match res with
        | Core.Result.Result_Ok x ->
          Core.Result.Result_Ok
          (Core.Convert.f_into (Libcrux.Kem.impl__Ss__encode x
                <:
                Alloc.Vec.t_Vec u8 Alloc.Alloc.t_Global))
        | Core.Result.Result_Err _ -> Bertie.Tls13utils.tlserr Bertie.Tls13utils.v_CRYPTO_ERROR))

type t_Algorithms =
  | Algorithms :
      t_HashAlgorithm ->
      t_AeadAlgorithm ->
      t_SignatureScheme ->
      t_KemScheme ->
      bool ->
      bool
    -> t_Algorithms

let hash_alg (algs: t_Algorithms) : t_HashAlgorithm = algs._0

let aead_alg (algs: t_Algorithms) : t_AeadAlgorithm = algs._1

let sig_alg (algs: t_Algorithms) : t_SignatureScheme = algs._2

let kem_alg (algs: t_Algorithms) : t_KemScheme = algs._3

let psk_mode (algs: t_Algorithms) : bool = algs._4

let zero_rtt (algs: t_Algorithms) : bool = algs._5