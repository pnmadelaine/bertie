module Bertie.Tls13cert
#set-options "--fuel 0 --ifuel 1 --z3rlimit 15"
open Core
open FStar.Mul

unfold
let t_Asn1Error = u8

let v_ASN1_ERROR: u8 = 25uy

let v_ASN1_INVALID_CERTIFICATE: u8 = 23uy

let v_ASN1_INVALID_TAG: u8 = 22uy

let v_ASN1_SEQUENCE_TOO_LONG: u8 = 21uy

let v_ASN1_UNSUPPORTED_ALGORITHM: u8 = 24uy

let asn1_error
      (#v_T: Type)
      (#[FStar.Tactics.Typeclasses.tcresolve ()] i0: Core.Marker.t_Sized v_T)
      (err: u8)
    : Core.Result.t_Result v_T u8 = Core.Result.Result_Err err <: Core.Result.t_Result v_T u8

let check_success (v_val: bool) : Core.Result.t_Result Prims.unit u8 =
  if v_val
  then Core.Result.Result_Ok (() <: Prims.unit) <: Core.Result.t_Result Prims.unit u8
  else asn1_error v_ASN1_ERROR

type t_CertificateKey = | CertificateKey : usize -> usize -> t_CertificateKey

unfold
let t_Spki = (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey)

let ecdsa_secp256r1_sha256_oid (_: Prims.unit) : Bertie.Tls13utils.t_Bytes =
  Core.Convert.f_into (let list = [42uy; 134uy; 72uy; 206uy; 61uy; 3uy; 1uy; 7uy] in
      FStar.Pervasives.assert_norm (Prims.eq2 (List.Tot.length list) 8);
      Rust_primitives.Hax.array_of_list list)

let rsa_pkcs1_encryption_oid (_: Prims.unit) : Bertie.Tls13utils.t_Bytes =
  Core.Convert.f_into (let list = [42uy; 134uy; 72uy; 134uy; 247uy; 13uy; 1uy; 1uy; 1uy] in
      FStar.Pervasives.assert_norm (Prims.eq2 (List.Tot.length list) 9);
      Rust_primitives.Hax.array_of_list list)

let x962_ec_public_key_oid (_: Prims.unit) : Bertie.Tls13utils.t_Bytes =
  Core.Convert.f_into (let list = [42uy; 134uy; 72uy; 206uy; 61uy; 2uy; 1uy] in
      FStar.Pervasives.assert_norm (Prims.eq2 (List.Tot.length list) 7);
      Rust_primitives.Hax.array_of_list list)

let check_tag (b: Bertie.Tls13utils.t_Bytes) (offset: usize) (value: u8)
    : Core.Result.t_Result Prims.unit u8 =
  if
    (Bertie.Tls13utils.impl__U8__declassify (b.[ offset ] <: Bertie.Tls13utils.t_U8) <: u8) =. value
  then Core.Result.Result_Ok (() <: Prims.unit) <: Core.Result.t_Result Prims.unit u8
  else asn1_error v_ASN1_INVALID_TAG

let length_length (b: Bertie.Tls13utils.t_Bytes) (offset: usize) : usize =
  if
    ((Bertie.Tls13utils.impl__U8__declassify (b.[ offset ] <: Bertie.Tls13utils.t_U8) <: u8) >>! 7l
      <:
      u8) =.
    1uy
  then
    cast ((Bertie.Tls13utils.impl__U8__declassify (b.[ offset ] <: Bertie.Tls13utils.t_U8) <: u8) &.
        127uy
        <:
        u8)
    <:
    usize
  else sz 0

let read_octet_header (b: Bertie.Tls13utils.t_Bytes) (offset: usize) : Core.Result.t_Result usize u8 =
  Rust_primitives.Hax.Control_flow_monad.Mexception.run (let* _:Prims.unit =
        match
          Core.Ops.Try_trait.f_branch (check_tag b offset 4uy <: Core.Result.t_Result Prims.unit u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist52:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result usize u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist52)
          <:
          Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result usize u8) Prims.unit
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result usize u8) Prims.unit
      in
      Core.Ops.Control_flow.ControlFlow_Continue
      (let offset:usize = offset +! sz 1 in
        let length_length:usize = length_length b offset in
        let offset:usize = (offset +! length_length <: usize) +! sz 1 in
        Core.Result.Result_Ok offset <: Core.Result.t_Result usize u8)
      <:
      Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result usize u8)
        (Core.Result.t_Result usize u8))

let read_sequence_header (b: Bertie.Tls13utils.t_Bytes) (offset: usize)
    : Core.Result.t_Result usize u8 =
  Rust_primitives.Hax.Control_flow_monad.Mexception.run (let* _:Prims.unit =
        match
          Core.Ops.Try_trait.f_branch (check_tag b offset 48uy <: Core.Result.t_Result Prims.unit u8
            )
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist53:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result usize u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist53)
          <:
          Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result usize u8) Prims.unit
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result usize u8) Prims.unit
      in
      Core.Ops.Control_flow.ControlFlow_Continue
      (let offset:usize = offset +! sz 1 in
        let length_length:usize = length_length b offset in
        let offset:usize = (offset +! length_length <: usize) +! sz 1 in
        Core.Result.Result_Ok offset <: Core.Result.t_Result usize u8)
      <:
      Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result usize u8)
        (Core.Result.t_Result usize u8))

let short_length (b: Bertie.Tls13utils.t_Bytes) (offset: usize) : Core.Result.t_Result usize u8 =
  if
    ((Bertie.Tls13utils.impl__U8__declassify (b.[ offset ] <: Bertie.Tls13utils.t_U8) <: u8) &.
      128uy
      <:
      u8) =.
    0uy
  then
    Core.Result.Result_Ok
    (cast ((Bertie.Tls13utils.impl__U8__declassify (b.[ offset ] <: Bertie.Tls13utils.t_U8) <: u8) &.
          127uy
          <:
          u8)
      <:
      usize)
    <:
    Core.Result.t_Result usize u8
  else asn1_error v_ASN1_ERROR

let read_version_number (b: Bertie.Tls13utils.t_Bytes) (offset: usize)
    : Core.Result.t_Result usize u8 =
  Rust_primitives.Hax.Control_flow_monad.Mexception.run (match
        check_tag b offset 160uy <: Core.Result.t_Result Prims.unit u8
      with
      | Core.Result.Result_Ok _ ->
        let offset:usize = offset +! sz 1 in
        let* length:usize =
          match
            Core.Ops.Try_trait.f_branch (short_length b offset <: Core.Result.t_Result usize u8)
          with
          | Core.Ops.Control_flow.ControlFlow_Break residual ->
            let* hoist54:Rust_primitives.Hax.t_Never =
              Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                  <:
                  Core.Result.t_Result usize u8)
            in
            Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist54)
            <:
            Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result usize u8) usize
          | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
            Core.Ops.Control_flow.ControlFlow_Continue v_val
            <:
            Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result usize u8) usize
        in
        Core.Ops.Control_flow.ControlFlow_Continue
        (Core.Result.Result_Ok ((offset +! sz 1 <: usize) +! length)
          <:
          Core.Result.t_Result usize u8)
        <:
        Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result usize u8)
          (Core.Result.t_Result usize u8)
      | Core.Result.Result_Err _ ->
        Core.Ops.Control_flow.ControlFlow_Continue
        (Core.Result.Result_Ok offset <: Core.Result.t_Result usize u8)
        <:
        Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result usize u8)
          (Core.Result.t_Result usize u8))

let ecdsa_public_key (cert: Bertie.Tls13utils.t_Bytes) (indices: t_CertificateKey)
    : Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8 =
  Rust_primitives.Hax.Control_flow_monad.Mexception.run (let CertificateKey offset len:t_CertificateKey
      =
        indices
      in
      let* _:Prims.unit =
        match
          Core.Ops.Try_trait.f_branch (check_tag cert offset 4uy
              <:
              Core.Result.t_Result Prims.unit u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist67:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist67)
          <:
          Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
            Prims.unit
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
            Prims.unit
      in
      Core.Ops.Control_flow.ControlFlow_Continue
      (Core.Result.Result_Ok
        (Bertie.Tls13utils.impl__Bytes__slice cert (offset +! sz 1 <: usize) (len -! sz 1 <: usize))
        <:
        Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
      <:
      Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
        (Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8))

let long_length (b: Bertie.Tls13utils.t_Bytes) (offset len: usize) : Core.Result.t_Result usize u8 =
  Rust_primitives.Hax.Control_flow_monad.Mexception.run (if len >. sz 4 <: bool
      then
        Core.Ops.Control_flow.ControlFlow_Continue
        (asn1_error v_ASN1_SEQUENCE_TOO_LONG <: Core.Result.t_Result usize u8)
        <:
        Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result usize u8)
          (Core.Result.t_Result usize u8)
      else
        let (u32word: Bertie.Tls13utils.t_Bytes):Bertie.Tls13utils.t_Bytes =
          Bertie.Tls13utils.impl__Bytes__zeroes (sz 4)
        in
        let u32word:Bertie.Tls13utils.t_Bytes =
          Rust_primitives.Hax.Monomorphized_update_at.update_at_range u32word
            ({ Core.Ops.Range.f_start = sz 0; Core.Ops.Range.f_end = len }
              <:
              Core.Ops.Range.t_Range usize)
            (Core.Slice.impl__copy_from_slice (u32word.[ {
                      Core.Ops.Range.f_start = sz 0;
                      Core.Ops.Range.f_end = len
                    }
                    <:
                    Core.Ops.Range.t_Range usize ]
                  <:
                  t_Slice Bertie.Tls13utils.t_U8)
                (b.[ {
                      Core.Ops.Range.f_start = offset;
                      Core.Ops.Range.f_end = offset +! len <: usize
                    }
                    <:
                    Core.Ops.Range.t_Range usize ]
                  <:
                  t_Slice Bertie.Tls13utils.t_U8)
              <:
              t_Slice Bertie.Tls13utils.t_U8)
        in
        let* hoist73:Bertie.Tls13utils.t_U32 =
          match
            Core.Ops.Try_trait.f_branch (Bertie.Tls13utils.impl__U32__from_be_bytes u32word
                <:
                Core.Result.t_Result Bertie.Tls13utils.t_U32 u8)
          with
          | Core.Ops.Control_flow.ControlFlow_Break residual ->
            let* hoist72:Rust_primitives.Hax.t_Never =
              Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                  <:
                  Core.Result.t_Result usize u8)
            in
            Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist72)
            <:
            Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result usize u8)
              Bertie.Tls13utils.t_U32
          | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
            Core.Ops.Control_flow.ControlFlow_Continue v_val
            <:
            Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result usize u8)
              Bertie.Tls13utils.t_U32
        in
        Core.Ops.Control_flow.ControlFlow_Continue
        (let hoist74:u32 = Bertie.Tls13utils.impl__U32__declassify hoist73 in
          let hoist75:usize = cast (hoist74 <: u32) <: usize in
          let hoist76:usize = hoist75 >>! ((sz 4 -! len <: usize) *! sz 8 <: usize) in
          Core.Result.Result_Ok hoist76 <: Core.Result.t_Result usize u8)
        <:
        Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result usize u8)
          (Core.Result.t_Result usize u8))

let length (b: Bertie.Tls13utils.t_Bytes) (offset: usize) : Core.Result.t_Result (usize & usize) u8 =
  Rust_primitives.Hax.Control_flow_monad.Mexception.run (if
        ((Bertie.Tls13utils.impl__U8__declassify (b.[ offset ] <: Bertie.Tls13utils.t_U8) <: u8) &.
          128uy
          <:
          u8) =.
        0uy
        <:
        bool
      then
        let* len:usize =
          match
            Core.Ops.Try_trait.f_branch (short_length b offset <: Core.Result.t_Result usize u8)
          with
          | Core.Ops.Control_flow.ControlFlow_Break residual ->
            let* hoist77:Rust_primitives.Hax.t_Never =
              Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                  <:
                  Core.Result.t_Result (usize & usize) u8)
            in
            Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist77)
            <:
            Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result (usize & usize) u8) usize
          | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
            Core.Ops.Control_flow.ControlFlow_Continue v_val
            <:
            Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result (usize & usize) u8) usize
        in
        Core.Ops.Control_flow.ControlFlow_Continue
        (Core.Result.Result_Ok (offset +! sz 1, len <: (usize & usize))
          <:
          Core.Result.t_Result (usize & usize) u8)
        <:
        Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result (usize & usize) u8)
          (Core.Result.t_Result (usize & usize) u8)
      else
        let len:usize = length_length b offset in
        let offset:usize = offset +! sz 1 in
        let* v_end:usize =
          match
            Core.Ops.Try_trait.f_branch (long_length b offset len <: Core.Result.t_Result usize u8)
          with
          | Core.Ops.Control_flow.ControlFlow_Break residual ->
            let* hoist78:Rust_primitives.Hax.t_Never =
              Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                  <:
                  Core.Result.t_Result (usize & usize) u8)
            in
            Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist78)
            <:
            Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result (usize & usize) u8) usize
          | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
            Core.Ops.Control_flow.ControlFlow_Continue v_val
            <:
            Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result (usize & usize) u8) usize
        in
        Core.Ops.Control_flow.ControlFlow_Continue
        (Core.Result.Result_Ok (offset +! len, v_end <: (usize & usize))
          <:
          Core.Result.t_Result (usize & usize) u8)
        <:
        Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result (usize & usize) u8)
          (Core.Result.t_Result (usize & usize) u8))

let read_integer (b: Bertie.Tls13utils.t_Bytes) (offset: usize)
    : Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8 =
  Rust_primitives.Hax.Control_flow_monad.Mexception.run (let* _:Prims.unit =
        match
          Core.Ops.Try_trait.f_branch (check_tag b offset 2uy <: Core.Result.t_Result Prims.unit u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist79:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist79)
          <:
          Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
            Prims.unit
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
            Prims.unit
      in
      let offset:usize = offset +! sz 1 in
      let* offset, length:(usize & usize) =
        match
          Core.Ops.Try_trait.f_branch (length b offset <: Core.Result.t_Result (usize & usize) u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist80:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist80)
          <:
          Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
            (usize & usize)
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
            (usize & usize)
      in
      Core.Ops.Control_flow.ControlFlow_Continue
      (Core.Result.Result_Ok (Bertie.Tls13utils.impl__Bytes__slice b offset length)
        <:
        Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
      <:
      Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
        (Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8))

let read_spki (cert: Bertie.Tls13utils.t_Bytes) (offset: usize)
    : Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8 =
  Rust_primitives.Hax.Control_flow_monad.Mexception.run (let* _:Prims.unit =
        match
          Core.Ops.Try_trait.f_branch (check_tag cert offset 48uy
              <:
              Core.Result.t_Result Prims.unit u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist81:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist81)
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
            Prims.unit
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
            Prims.unit
      in
      let offset:usize = offset +! sz 1 in
      let* offset, v__seq_len:(usize & usize) =
        match
          Core.Ops.Try_trait.f_branch (length cert offset <: Core.Result.t_Result (usize & usize) u8
            )
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist82:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist82)
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
            (usize & usize)
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
            (usize & usize)
      in
      let* _:Prims.unit =
        match
          Core.Ops.Try_trait.f_branch (check_tag cert offset 48uy
              <:
              Core.Result.t_Result Prims.unit u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist83:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist83)
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
            Prims.unit
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
            Prims.unit
      in
      let offset:usize = offset +! sz 1 in
      let* offset, seq_len:(usize & usize) =
        match
          Core.Ops.Try_trait.f_branch (length cert offset <: Core.Result.t_Result (usize & usize) u8
            )
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist84:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist84)
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
            (usize & usize)
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
            (usize & usize)
      in
      let* _:Prims.unit =
        match
          Core.Ops.Try_trait.f_branch (check_tag cert offset 6uy
              <:
              Core.Result.t_Result Prims.unit u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist85:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist85)
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
            Prims.unit
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
            Prims.unit
      in
      let* oid_offset, oid_len:(usize & usize) =
        match
          Core.Ops.Try_trait.f_branch (length cert (offset +! sz 1 <: usize)
              <:
              Core.Result.t_Result (usize & usize) u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist86:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist86)
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
            (usize & usize)
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
            (usize & usize)
      in
      let ec_pk_oid, ecdsa_p256, rsa_pk_oid:(bool & bool & bool) =
        false, false, false <: (bool & bool & bool)
      in
      let ec_oid:Bertie.Tls13utils.t_Bytes = x962_ec_public_key_oid () in
      let rsa_oid:Bertie.Tls13utils.t_Bytes = rsa_pkcs1_encryption_oid () in
      let* ec_pk_oid, ecdsa_p256, oid_offset:(bool & bool & usize) =
        if (Bertie.Tls13utils.impl__Bytes__len ec_oid <: usize) =. oid_len
        then
          let ec_pk_oid:bool = true in
          let ec_pk_oid:bool =
            Core.Iter.Traits.Iterator.f_fold (Core.Iter.Traits.Collect.f_into_iter ({
                      Core.Ops.Range.f_start = sz 0;
                      Core.Ops.Range.f_end = Bertie.Tls13utils.impl__Bytes__len ec_oid <: usize
                    }
                    <:
                    Core.Ops.Range.t_Range usize)
                <:
                Core.Ops.Range.t_Range usize)
              ec_pk_oid
              (fun ec_pk_oid i ->
                  let ec_pk_oid:bool = ec_pk_oid in
                  let i:usize = i in
                  let oid_byte_equal:bool =
                    (Bertie.Tls13utils.impl__U8__declassify (cert.[ oid_offset +! i <: usize ]
                          <:
                          Bertie.Tls13utils.t_U8)
                      <:
                      u8) =.
                    (Bertie.Tls13utils.impl__U8__declassify (ec_oid.[ i ] <: Bertie.Tls13utils.t_U8)
                      <:
                      u8)
                  in
                  let ec_pk_oid:bool = ec_pk_oid && oid_byte_equal in
                  ec_pk_oid)
          in
          if ec_pk_oid
          then
            let oid_offset:usize = oid_offset +! oid_len in
            let* _:Prims.unit =
              match
                Core.Ops.Try_trait.f_branch (check_tag cert oid_offset 6uy
                    <:
                    Core.Result.t_Result Prims.unit u8)
              with
              | Core.Ops.Control_flow.ControlFlow_Break residual ->
                let* hoist87:Rust_primitives.Hax.t_Never =
                  Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual

                      <:
                      Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey)
                        u8)
                in
                Core.Ops.Control_flow.ControlFlow_Continue
                (Rust_primitives.Hax.never_to_any hoist87)
                <:
                Core.Ops.Control_flow.t_ControlFlow
                  (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8
                  ) Prims.unit
              | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
                Core.Ops.Control_flow.ControlFlow_Continue v_val
                <:
                Core.Ops.Control_flow.t_ControlFlow
                  (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8
                  ) Prims.unit
            in
            let oid_offset:usize = oid_offset +! sz 1 in
            let* oid_offset, v__oid_len:(usize & usize) =
              match
                Core.Ops.Try_trait.f_branch (length cert oid_offset
                    <:
                    Core.Result.t_Result (usize & usize) u8)
              with
              | Core.Ops.Control_flow.ControlFlow_Break residual ->
                let* hoist88:Rust_primitives.Hax.t_Never =
                  Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual

                      <:
                      Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey)
                        u8)
                in
                Core.Ops.Control_flow.ControlFlow_Continue
                (Rust_primitives.Hax.never_to_any hoist88)
                <:
                Core.Ops.Control_flow.t_ControlFlow
                  (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8
                  ) (usize & usize)
              | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
                Core.Ops.Control_flow.ControlFlow_Continue v_val
                <:
                Core.Ops.Control_flow.t_ControlFlow
                  (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8
                  ) (usize & usize)
            in
            let ecdsa_p256:bool = true in
            let ec_oid:Bertie.Tls13utils.t_Bytes = ecdsa_secp256r1_sha256_oid () in
            let ecdsa_p256:bool =
              Core.Iter.Traits.Iterator.f_fold (Core.Iter.Traits.Collect.f_into_iter ({
                        Core.Ops.Range.f_start = sz 0;
                        Core.Ops.Range.f_end = Bertie.Tls13utils.impl__Bytes__len ec_oid <: usize
                      }
                      <:
                      Core.Ops.Range.t_Range usize)
                  <:
                  Core.Ops.Range.t_Range usize)
                ecdsa_p256
                (fun ecdsa_p256 i ->
                    let ecdsa_p256:bool = ecdsa_p256 in
                    let i:usize = i in
                    let oid_byte_equal:bool =
                      (Bertie.Tls13utils.impl__U8__declassify (cert.[ oid_offset +! i <: usize ]
                            <:
                            Bertie.Tls13utils.t_U8)
                        <:
                        u8) =.
                      (Bertie.Tls13utils.impl__U8__declassify (ec_oid.[ i ]
                            <:
                            Bertie.Tls13utils.t_U8)
                        <:
                        u8)
                    in
                    let ecdsa_p256:bool = ecdsa_p256 && oid_byte_equal in
                    ecdsa_p256)
            in
            let* _:Prims.unit =
              match
                Core.Ops.Try_trait.f_branch (check_success ecdsa_p256
                    <:
                    Core.Result.t_Result Prims.unit u8)
              with
              | Core.Ops.Control_flow.ControlFlow_Break residual ->
                let* hoist89:Rust_primitives.Hax.t_Never =
                  Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual

                      <:
                      Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey)
                        u8)
                in
                Core.Ops.Control_flow.ControlFlow_Continue
                (Rust_primitives.Hax.never_to_any hoist89)
                <:
                Core.Ops.Control_flow.t_ControlFlow
                  (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8
                  ) Prims.unit
              | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
                Core.Ops.Control_flow.ControlFlow_Continue v_val
                <:
                Core.Ops.Control_flow.t_ControlFlow
                  (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8
                  ) Prims.unit
            in
            Core.Ops.Control_flow.ControlFlow_Continue
            (ec_pk_oid, ecdsa_p256, oid_offset <: (bool & bool & usize))
            <:
            Core.Ops.Control_flow.t_ControlFlow
              (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
              (bool & bool & usize)
          else
            Core.Ops.Control_flow.ControlFlow_Continue
            (ec_pk_oid, ecdsa_p256, oid_offset <: (bool & bool & usize))
            <:
            Core.Ops.Control_flow.t_ControlFlow
              (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
              (bool & bool & usize)
        else
          Core.Ops.Control_flow.ControlFlow_Continue
          (ec_pk_oid, ecdsa_p256, oid_offset <: (bool & bool & usize))
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
            (bool & bool & usize)
      in
      let rsa_pk_oid:bool =
        if (Bertie.Tls13utils.impl__Bytes__len rsa_oid <: usize) =. oid_len
        then
          let rsa_pk_oid:bool = true in
          Core.Iter.Traits.Iterator.f_fold (Core.Iter.Traits.Collect.f_into_iter ({
                    Core.Ops.Range.f_start = sz 0;
                    Core.Ops.Range.f_end = Bertie.Tls13utils.impl__Bytes__len rsa_oid <: usize
                  }
                  <:
                  Core.Ops.Range.t_Range usize)
              <:
              Core.Ops.Range.t_Range usize)
            rsa_pk_oid
            (fun rsa_pk_oid i ->
                let rsa_pk_oid:bool = rsa_pk_oid in
                let i:usize = i in
                let oid_byte_equal:bool =
                  (Bertie.Tls13utils.impl__U8__declassify (cert.[ oid_offset +! i <: usize ]
                        <:
                        Bertie.Tls13utils.t_U8)
                    <:
                    u8) =.
                  (Bertie.Tls13utils.impl__U8__declassify (rsa_oid.[ i ] <: Bertie.Tls13utils.t_U8)
                    <:
                    u8)
                in
                let rsa_pk_oid:bool = rsa_pk_oid && oid_byte_equal in
                rsa_pk_oid)
        else rsa_pk_oid
      in
      let* _:Prims.unit =
        match
          Core.Ops.Try_trait.f_branch (check_success (ec_pk_oid && ecdsa_p256 || rsa_pk_oid)
              <:
              Core.Result.t_Result Prims.unit u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist90:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist90)
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
            Prims.unit
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
            Prims.unit
      in
      let offset:usize = offset +! seq_len in
      let* _:Prims.unit =
        match
          Core.Ops.Try_trait.f_branch (check_tag cert offset 3uy
              <:
              Core.Result.t_Result Prims.unit u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist91:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist91)
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
            Prims.unit
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
            Prims.unit
      in
      let offset:usize = offset +! sz 1 in
      let* offset, bit_string_len:(usize & usize) =
        match
          Core.Ops.Try_trait.f_branch (length cert offset <: Core.Result.t_Result (usize & usize) u8
            )
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist92:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist92)
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
            (usize & usize)
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
            (usize & usize)
      in
      Core.Ops.Control_flow.ControlFlow_Continue
      (let offset:usize =
          if
            (Bertie.Tls13utils.impl__U8__declassify (cert.[ offset ] <: Bertie.Tls13utils.t_U8)
              <:
              u8) =.
            0uy
          then
            let offset:usize = offset +! sz 1 in
            offset
          else offset
        in
        if ec_pk_oid && ecdsa_p256
        then
          Core.Result.Result_Ok
          ((Bertie.Tls13crypto.SignatureScheme_EcdsaSecp256r1Sha256
              <:
              Bertie.Tls13crypto.t_SignatureScheme),
            (CertificateKey offset (bit_string_len -! sz 1) <: t_CertificateKey)
            <:
            (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey))
          <:
          Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8
        else
          if rsa_pk_oid
          then
            Core.Result.Result_Ok
            ((Bertie.Tls13crypto.SignatureScheme_RsaPssRsaSha256
                <:
                Bertie.Tls13crypto.t_SignatureScheme),
              (CertificateKey offset (bit_string_len -! sz 1) <: t_CertificateKey)
              <:
              (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey))
            <:
            Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8
          else asn1_error v_ASN1_INVALID_CERTIFICATE)
      <:
      Core.Ops.Control_flow.t_ControlFlow
        (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
        (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8))

let skip_integer (b: Bertie.Tls13utils.t_Bytes) (offset: usize) : Core.Result.t_Result usize u8 =
  Rust_primitives.Hax.Control_flow_monad.Mexception.run (let* _:Prims.unit =
        match
          Core.Ops.Try_trait.f_branch (check_tag b offset 2uy <: Core.Result.t_Result Prims.unit u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist93:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result usize u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist93)
          <:
          Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result usize u8) Prims.unit
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result usize u8) Prims.unit
      in
      let offset:usize = offset +! sz 1 in
      let* offset, length:(usize & usize) =
        match
          Core.Ops.Try_trait.f_branch (length b offset <: Core.Result.t_Result (usize & usize) u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist94:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result usize u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist94)
          <:
          Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result usize u8) (usize & usize)
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result usize u8) (usize & usize)
      in
      Core.Ops.Control_flow.ControlFlow_Continue
      (Core.Result.Result_Ok (offset +! length) <: Core.Result.t_Result usize u8)
      <:
      Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result usize u8)
        (Core.Result.t_Result usize u8))

let skip_sequence (b: Bertie.Tls13utils.t_Bytes) (offset: usize) : Core.Result.t_Result usize u8 =
  Rust_primitives.Hax.Control_flow_monad.Mexception.run (let* _:Prims.unit =
        match
          Core.Ops.Try_trait.f_branch (check_tag b offset 48uy <: Core.Result.t_Result Prims.unit u8
            )
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist95:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result usize u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist95)
          <:
          Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result usize u8) Prims.unit
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result usize u8) Prims.unit
      in
      let offset:usize = offset +! sz 1 in
      let* offset, length:(usize & usize) =
        match
          Core.Ops.Try_trait.f_branch (length b offset <: Core.Result.t_Result (usize & usize) u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist96:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result usize u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist96)
          <:
          Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result usize u8) (usize & usize)
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result usize u8) (usize & usize)
      in
      Core.Ops.Control_flow.ControlFlow_Continue
      (Core.Result.Result_Ok (offset +! length) <: Core.Result.t_Result usize u8)
      <:
      Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result usize u8)
        (Core.Result.t_Result usize u8))

let rsa_private_key (key: Bertie.Tls13utils.t_Bytes)
    : Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8 =
  Rust_primitives.Hax.Control_flow_monad.Mexception.run (let* offset:usize =
        match
          Core.Ops.Try_trait.f_branch (read_sequence_header key (sz 0)
              <:
              Core.Result.t_Result usize u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist97:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist97)
          <:
          Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
            usize
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
            usize
      in
      let* hoist99:usize =
        match
          Core.Ops.Try_trait.f_branch (skip_integer key offset <: Core.Result.t_Result usize u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist98:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist98)
          <:
          Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
            usize
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
            usize
      in
      let offset:usize = hoist99 in
      let* hoist101:usize =
        match
          Core.Ops.Try_trait.f_branch (skip_sequence key offset <: Core.Result.t_Result usize u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist100:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist100)
          <:
          Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
            usize
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
            usize
      in
      let offset:usize = hoist101 in
      let* hoist103:usize =
        match
          Core.Ops.Try_trait.f_branch (read_octet_header key offset <: Core.Result.t_Result usize u8
            )
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist102:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist102)
          <:
          Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
            usize
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
            usize
      in
      let offset:usize = hoist103 in
      let* hoist105:usize =
        match
          Core.Ops.Try_trait.f_branch (read_sequence_header key offset
              <:
              Core.Result.t_Result usize u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist104:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist104)
          <:
          Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
            usize
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
            usize
      in
      let offset:usize = hoist105 in
      let* hoist107:usize =
        match
          Core.Ops.Try_trait.f_branch (skip_integer key offset <: Core.Result.t_Result usize u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist106:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist106)
          <:
          Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
            usize
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
            usize
      in
      let offset:usize = hoist107 in
      let* hoist109:usize =
        match
          Core.Ops.Try_trait.f_branch (skip_integer key offset <: Core.Result.t_Result usize u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist108:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist108)
          <:
          Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
            usize
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
            usize
      in
      let offset:usize = hoist109 in
      let* hoist111:usize =
        match
          Core.Ops.Try_trait.f_branch (skip_integer key offset <: Core.Result.t_Result usize u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist110:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist110)
          <:
          Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
            usize
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
            usize
      in
      Core.Ops.Control_flow.ControlFlow_Continue
      (let offset:usize = hoist111 in
        read_integer key offset)
      <:
      Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
        (Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8))

let verification_key_from_cert (cert: Bertie.Tls13utils.t_Bytes)
    : Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8 =
  Rust_primitives.Hax.Control_flow_monad.Mexception.run (let* offset:usize =
        match
          Core.Ops.Try_trait.f_branch (read_sequence_header cert (sz 0)
              <:
              Core.Result.t_Result usize u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist112:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist112)
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
            usize
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
            usize
      in
      let* hoist114:usize =
        match
          Core.Ops.Try_trait.f_branch (read_sequence_header cert offset
              <:
              Core.Result.t_Result usize u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist113:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist113)
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
            usize
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
            usize
      in
      let offset:usize = hoist114 in
      let* hoist116:usize =
        match
          Core.Ops.Try_trait.f_branch (read_version_number cert offset
              <:
              Core.Result.t_Result usize u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist115:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist115)
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
            usize
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
            usize
      in
      let offset:usize = hoist116 in
      let* hoist118:usize =
        match
          Core.Ops.Try_trait.f_branch (skip_integer cert offset <: Core.Result.t_Result usize u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist117:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist117)
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
            usize
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
            usize
      in
      let offset:usize = hoist118 in
      let* hoist120:usize =
        match
          Core.Ops.Try_trait.f_branch (skip_sequence cert offset <: Core.Result.t_Result usize u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist119:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist119)
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
            usize
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
            usize
      in
      let offset:usize = hoist120 in
      let* hoist122:usize =
        match
          Core.Ops.Try_trait.f_branch (skip_sequence cert offset <: Core.Result.t_Result usize u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist121:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist121)
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
            usize
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
            usize
      in
      let offset:usize = hoist122 in
      let* hoist124:usize =
        match
          Core.Ops.Try_trait.f_branch (skip_sequence cert offset <: Core.Result.t_Result usize u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist123:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist123)
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
            usize
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
            usize
      in
      let offset:usize = hoist124 in
      let* hoist126:usize =
        match
          Core.Ops.Try_trait.f_branch (skip_sequence cert offset <: Core.Result.t_Result usize u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist125:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist125)
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
            usize
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
            usize
      in
      Core.Ops.Control_flow.ControlFlow_Continue
      (let offset:usize = hoist126 in
        read_spki cert offset)
      <:
      Core.Ops.Control_flow.t_ControlFlow
        (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8)
        (Core.Result.t_Result (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey) u8))

let rsa_public_key (cert: Bertie.Tls13utils.t_Bytes) (indices: t_CertificateKey)
    : Core.Result.t_Result Bertie.Tls13crypto.t_RsaVerificationKey u8 =
  Rust_primitives.Hax.Control_flow_monad.Mexception.run (let CertificateKey offset v__len:t_CertificateKey
      =
        indices
      in
      let* _:Prims.unit =
        match
          Core.Ops.Try_trait.f_branch (check_tag cert offset 48uy
              <:
              Core.Result.t_Result Prims.unit u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist269:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result Bertie.Tls13crypto.t_RsaVerificationKey u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist269)
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result Bertie.Tls13crypto.t_RsaVerificationKey u8) Prims.unit
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result Bertie.Tls13crypto.t_RsaVerificationKey u8) Prims.unit
      in
      let offset:usize = offset +! sz 1 in
      let* offset, v__seq_len:(usize & usize) =
        match
          Core.Ops.Try_trait.f_branch (length cert offset <: Core.Result.t_Result (usize & usize) u8
            )
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist270:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result Bertie.Tls13crypto.t_RsaVerificationKey u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist270)
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result Bertie.Tls13crypto.t_RsaVerificationKey u8) (usize & usize)
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result Bertie.Tls13crypto.t_RsaVerificationKey u8) (usize & usize)
      in
      let* _:Prims.unit =
        match
          Core.Ops.Try_trait.f_branch (check_tag cert offset 2uy
              <:
              Core.Result.t_Result Prims.unit u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist271:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result Bertie.Tls13crypto.t_RsaVerificationKey u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist271)
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result Bertie.Tls13crypto.t_RsaVerificationKey u8) Prims.unit
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result Bertie.Tls13crypto.t_RsaVerificationKey u8) Prims.unit
      in
      let offset:usize = offset +! sz 1 in
      let* offset, int_len:(usize & usize) =
        match
          Core.Ops.Try_trait.f_branch (length cert offset <: Core.Result.t_Result (usize & usize) u8
            )
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist272:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result Bertie.Tls13crypto.t_RsaVerificationKey u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist272)
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result Bertie.Tls13crypto.t_RsaVerificationKey u8) (usize & usize)
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result Bertie.Tls13crypto.t_RsaVerificationKey u8) (usize & usize)
      in
      let n:Bertie.Tls13utils.t_Bytes = Bertie.Tls13utils.impl__Bytes__slice cert offset int_len in
      let offset:usize = offset +! int_len in
      let* _:Prims.unit =
        match
          Core.Ops.Try_trait.f_branch (check_tag cert offset 2uy
              <:
              Core.Result.t_Result Prims.unit u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist273:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result Bertie.Tls13crypto.t_RsaVerificationKey u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist273)
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result Bertie.Tls13crypto.t_RsaVerificationKey u8) Prims.unit
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result Bertie.Tls13crypto.t_RsaVerificationKey u8) Prims.unit
      in
      let offset:usize = offset +! sz 1 in
      let* offset, int_len:(usize & usize) =
        match
          Core.Ops.Try_trait.f_branch (length cert offset <: Core.Result.t_Result (usize & usize) u8
            )
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist274:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result Bertie.Tls13crypto.t_RsaVerificationKey u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist274)
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result Bertie.Tls13crypto.t_RsaVerificationKey u8) (usize & usize)
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result Bertie.Tls13crypto.t_RsaVerificationKey u8) (usize & usize)
      in
      Core.Ops.Control_flow.ControlFlow_Continue
      (let e:Bertie.Tls13utils.t_Bytes = Bertie.Tls13utils.impl__Bytes__slice cert offset int_len in
        Core.Result.Result_Ok
        ({ Bertie.Tls13crypto.f_modulus = n; Bertie.Tls13crypto.f_exponent = e }
          <:
          Bertie.Tls13crypto.t_RsaVerificationKey)
        <:
        Core.Result.t_Result Bertie.Tls13crypto.t_RsaVerificationKey u8)
      <:
      Core.Ops.Control_flow.t_ControlFlow
        (Core.Result.t_Result Bertie.Tls13crypto.t_RsaVerificationKey u8)
        (Core.Result.t_Result Bertie.Tls13crypto.t_RsaVerificationKey u8))

let cert_public_key
      (certificate: Bertie.Tls13utils.t_Bytes)
      (spki: (Bertie.Tls13crypto.t_SignatureScheme & t_CertificateKey))
    : Core.Result.t_Result Bertie.Tls13crypto.t_PublicVerificationKey u8 =
  Rust_primitives.Hax.Control_flow_monad.Mexception.run (match spki._1 with
      | Bertie.Tls13crypto.SignatureScheme_ED25519  ->
        Core.Ops.Control_flow.ControlFlow_Continue
        (asn1_error v_ASN1_UNSUPPORTED_ALGORITHM
          <:
          Core.Result.t_Result Bertie.Tls13crypto.t_PublicVerificationKey u8)
        <:
        Core.Ops.Control_flow.t_ControlFlow
          (Core.Result.t_Result Bertie.Tls13crypto.t_PublicVerificationKey u8)
          (Core.Result.t_Result Bertie.Tls13crypto.t_PublicVerificationKey u8)
      | Bertie.Tls13crypto.SignatureScheme_EcdsaSecp256r1Sha256  ->
        let* pk:Bertie.Tls13utils.t_Bytes =
          match
            Core.Ops.Try_trait.f_branch (ecdsa_public_key certificate spki._2
                <:
                Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
          with
          | Core.Ops.Control_flow.ControlFlow_Break residual ->
            let* hoist275:Rust_primitives.Hax.t_Never =
              Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                  <:
                  Core.Result.t_Result Bertie.Tls13crypto.t_PublicVerificationKey u8)
            in
            Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist275)
            <:
            Core.Ops.Control_flow.t_ControlFlow
              (Core.Result.t_Result Bertie.Tls13crypto.t_PublicVerificationKey u8)
              Bertie.Tls13utils.t_Bytes
          | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
            Core.Ops.Control_flow.ControlFlow_Continue v_val
            <:
            Core.Ops.Control_flow.t_ControlFlow
              (Core.Result.t_Result Bertie.Tls13crypto.t_PublicVerificationKey u8)
              Bertie.Tls13utils.t_Bytes
        in
        Core.Ops.Control_flow.ControlFlow_Continue
        (Core.Result.Result_Ok
          (Bertie.Tls13crypto.PublicVerificationKey_EcDsa pk
            <:
            Bertie.Tls13crypto.t_PublicVerificationKey)
          <:
          Core.Result.t_Result Bertie.Tls13crypto.t_PublicVerificationKey u8)
        <:
        Core.Ops.Control_flow.t_ControlFlow
          (Core.Result.t_Result Bertie.Tls13crypto.t_PublicVerificationKey u8)
          (Core.Result.t_Result Bertie.Tls13crypto.t_PublicVerificationKey u8)
      | Bertie.Tls13crypto.SignatureScheme_RsaPssRsaSha256  ->
        let* pk:Bertie.Tls13crypto.t_RsaVerificationKey =
          match
            Core.Ops.Try_trait.f_branch (rsa_public_key certificate spki._2
                <:
                Core.Result.t_Result Bertie.Tls13crypto.t_RsaVerificationKey u8)
          with
          | Core.Ops.Control_flow.ControlFlow_Break residual ->
            let* hoist276:Rust_primitives.Hax.t_Never =
              Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                  <:
                  Core.Result.t_Result Bertie.Tls13crypto.t_PublicVerificationKey u8)
            in
            Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist276)
            <:
            Core.Ops.Control_flow.t_ControlFlow
              (Core.Result.t_Result Bertie.Tls13crypto.t_PublicVerificationKey u8)
              Bertie.Tls13crypto.t_RsaVerificationKey
          | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
            Core.Ops.Control_flow.ControlFlow_Continue v_val
            <:
            Core.Ops.Control_flow.t_ControlFlow
              (Core.Result.t_Result Bertie.Tls13crypto.t_PublicVerificationKey u8)
              Bertie.Tls13crypto.t_RsaVerificationKey
        in
        Core.Ops.Control_flow.ControlFlow_Continue
        (Core.Result.Result_Ok
          (Bertie.Tls13crypto.PublicVerificationKey_Rsa pk
            <:
            Bertie.Tls13crypto.t_PublicVerificationKey)
          <:
          Core.Result.t_Result Bertie.Tls13crypto.t_PublicVerificationKey u8)
        <:
        Core.Ops.Control_flow.t_ControlFlow
          (Core.Result.t_Result Bertie.Tls13crypto.t_PublicVerificationKey u8)
          (Core.Result.t_Result Bertie.Tls13crypto.t_PublicVerificationKey u8))
