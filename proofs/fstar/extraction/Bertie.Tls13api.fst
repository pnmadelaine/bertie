module Bertie.Tls13api
#set-options "--fuel 0 --ifuel 1 --z3rlimit 15"
open Core
open FStar.Mul

type t_Client =
  | Client_Client0 :
      Bertie.Tls13handshake.t_ClientPostClientHello ->
      Core.Option.t_Option Bertie.Tls13record.t_ClientCipherState0
    -> t_Client
  | Client_ClientH :
      Bertie.Tls13handshake.t_ClientPostServerHello ->
      Core.Option.t_Option Bertie.Tls13record.t_ClientCipherState0 ->
      Bertie.Tls13record.t_DuplexCipherStateH ->
      Bertie.Tls13utils.t_HandshakeData
    -> t_Client
  | Client_Client1 :
      Bertie.Tls13handshake.t_ClientPostClientFinished ->
      Bertie.Tls13record.t_DuplexCipherState1
    -> t_Client

let impl__Client__read (self: t_Client) (message_bytes: Bertie.Tls13utils.t_Bytes)
    : Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_AppData & t_Client) u8 =
  Rust_primitives.Hax.Control_flow_monad.Mexception.run (match self with
      | Client_Client1 state cipher1 ->
        let* ty, hd, cipher1:(Bertie.Tls13formats.t_ContentType & Bertie.Tls13utils.t_Bytes &
          Bertie.Tls13record.t_DuplexCipherState1) =
          match
            Core.Ops.Try_trait.f_branch (Bertie.Tls13record.decrypt_data_or_hs message_bytes cipher1
                <:
                Core.Result.t_Result
                  (Bertie.Tls13formats.t_ContentType & Bertie.Tls13utils.t_Bytes &
                    Bertie.Tls13record.t_DuplexCipherState1) u8)
          with
          | Core.Ops.Control_flow.ControlFlow_Break residual ->
            let* hoist466:Rust_primitives.Hax.t_Never =
              Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                  <:
                  Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_AppData & t_Client)
                    u8)
            in
            Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist466)
            <:
            Core.Ops.Control_flow.t_ControlFlow
              (Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_AppData & t_Client) u8
              )
              (Bertie.Tls13formats.t_ContentType & Bertie.Tls13utils.t_Bytes &
                Bertie.Tls13record.t_DuplexCipherState1)
          | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
            Core.Ops.Control_flow.ControlFlow_Continue v_val
            <:
            Core.Ops.Control_flow.t_ControlFlow
              (Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_AppData & t_Client) u8
              )
              (Bertie.Tls13formats.t_ContentType & Bertie.Tls13utils.t_Bytes &
                Bertie.Tls13record.t_DuplexCipherState1)
        in
        Core.Ops.Control_flow.ControlFlow_Continue
        (match ty with
          | Bertie.Tls13formats.ContentType_ApplicationData  ->
            Core.Result.Result_Ok
            ((Core.Option.Option_Some (Bertie.Tls13utils.impl__AppData__new hd)
                <:
                Core.Option.t_Option Bertie.Tls13utils.t_AppData),
              (Client_Client1 state cipher1 <: t_Client)
              <:
              (Core.Option.t_Option Bertie.Tls13utils.t_AppData & t_Client))
            <:
            Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_AppData & t_Client) u8
          | Bertie.Tls13formats.ContentType_Handshake  ->
            let _:Prims.unit =
              Std.Io.Stdio.v__print (Core.Fmt.impl_2__new_const (Rust_primitives.unsize (let list =
                            ["Received Session Ticket\n"]
                          in
                          FStar.Pervasives.assert_norm (Prims.eq2 (List.Tot.length list) 1);
                          Rust_primitives.Hax.array_of_list list)
                      <:
                      t_Slice string)
                  <:
                  Core.Fmt.t_Arguments)
            in
            let _:Prims.unit = () in
            Core.Result.Result_Ok
            ((Core.Option.Option_None <: Core.Option.t_Option Bertie.Tls13utils.t_AppData),
              (Client_Client1 state cipher1 <: t_Client)
              <:
              (Core.Option.t_Option Bertie.Tls13utils.t_AppData & t_Client))
            <:
            Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_AppData & t_Client) u8
          | _ ->
            Core.Result.Result_Err Bertie.Tls13utils.v_PARSE_FAILED
            <:
            Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_AppData & t_Client) u8)
        <:
        Core.Ops.Control_flow.t_ControlFlow
          (Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_AppData & t_Client) u8)
          (Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_AppData & t_Client) u8)
      | _ ->
        Core.Ops.Control_flow.ControlFlow_Continue
        (Core.Result.Result_Err Bertie.Tls13utils.v_INCORRECT_STATE
          <:
          Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_AppData & t_Client) u8)
        <:
        Core.Ops.Control_flow.t_ControlFlow
          (Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_AppData & t_Client) u8)
          (Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_AppData & t_Client) u8))

let client_write (d: Bertie.Tls13utils.t_AppData) (st: t_Client)
    : Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & t_Client) u8 =
  Rust_primitives.Hax.Control_flow_monad.Mexception.run (match st with
      | Client_Client1 cstate cipher1 ->
        let* v_by, cipher1:(Bertie.Tls13utils.t_Bytes & Bertie.Tls13record.t_DuplexCipherState1) =
          match
            Core.Ops.Try_trait.f_branch (Bertie.Tls13record.encrypt_data d (sz 0) cipher1
                <:
                Core.Result.t_Result
                  (Bertie.Tls13utils.t_Bytes & Bertie.Tls13record.t_DuplexCipherState1) u8)
          with
          | Core.Ops.Control_flow.ControlFlow_Break residual ->
            let* hoist467:Rust_primitives.Hax.t_Never =
              Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                  <:
                  Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & t_Client) u8)
            in
            Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist467)
            <:
            Core.Ops.Control_flow.t_ControlFlow
              (Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & t_Client) u8)
              (Bertie.Tls13utils.t_Bytes & Bertie.Tls13record.t_DuplexCipherState1)
          | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
            Core.Ops.Control_flow.ControlFlow_Continue v_val
            <:
            Core.Ops.Control_flow.t_ControlFlow
              (Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & t_Client) u8)
              (Bertie.Tls13utils.t_Bytes & Bertie.Tls13record.t_DuplexCipherState1)
        in
        Core.Ops.Control_flow.ControlFlow_Continue
        (Core.Result.Result_Ok
          (v_by, (Client_Client1 cstate cipher1 <: t_Client)
            <:
            (Bertie.Tls13utils.t_Bytes & t_Client))
          <:
          Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & t_Client) u8)
        <:
        Core.Ops.Control_flow.t_ControlFlow
          (Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & t_Client) u8)
          (Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & t_Client) u8)
      | _ ->
        Core.Ops.Control_flow.ControlFlow_Continue
        (Core.Result.Result_Err Bertie.Tls13utils.v_INCORRECT_STATE
          <:
          Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & t_Client) u8)
        <:
        Core.Ops.Control_flow.t_ControlFlow
          (Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & t_Client) u8)
          (Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & t_Client) u8))

type t_Server =
  | Server_ServerH :
      Bertie.Tls13handshake.t_ServerPostServerFinished ->
      Core.Option.t_Option Bertie.Tls13record.t_ServerCipherState0 ->
      Bertie.Tls13record.t_DuplexCipherStateH ->
      Bertie.Tls13record.t_DuplexCipherState1
    -> t_Server
  | Server_Server1 :
      Bertie.Tls13handshake.t_ServerPostClientFinished ->
      Bertie.Tls13record.t_DuplexCipherState1
    -> t_Server

let server_read (d: Bertie.Tls13utils.t_Bytes) (st: t_Server)
    : Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_AppData & t_Server) u8 =
  Rust_primitives.Hax.Control_flow_monad.Mexception.run (match st with
      | Server_Server1 sstate cipher1 ->
        let* ad, cipher1:(Bertie.Tls13utils.t_AppData & Bertie.Tls13record.t_DuplexCipherState1) =
          match
            Core.Ops.Try_trait.f_branch (Bertie.Tls13record.decrypt_data d cipher1
                <:
                Core.Result.t_Result
                  (Bertie.Tls13utils.t_AppData & Bertie.Tls13record.t_DuplexCipherState1) u8)
          with
          | Core.Ops.Control_flow.ControlFlow_Break residual ->
            let* hoist468:Rust_primitives.Hax.t_Never =
              Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                  <:
                  Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_AppData & t_Server)
                    u8)
            in
            Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist468)
            <:
            Core.Ops.Control_flow.t_ControlFlow
              (Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_AppData & t_Server) u8
              ) (Bertie.Tls13utils.t_AppData & Bertie.Tls13record.t_DuplexCipherState1)
          | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
            Core.Ops.Control_flow.ControlFlow_Continue v_val
            <:
            Core.Ops.Control_flow.t_ControlFlow
              (Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_AppData & t_Server) u8
              ) (Bertie.Tls13utils.t_AppData & Bertie.Tls13record.t_DuplexCipherState1)
        in
        Core.Ops.Control_flow.ControlFlow_Continue
        (Core.Result.Result_Ok
          ((Core.Option.Option_Some ad <: Core.Option.t_Option Bertie.Tls13utils.t_AppData),
            (Server_Server1 sstate cipher1 <: t_Server)
            <:
            (Core.Option.t_Option Bertie.Tls13utils.t_AppData & t_Server))
          <:
          Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_AppData & t_Server) u8)
        <:
        Core.Ops.Control_flow.t_ControlFlow
          (Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_AppData & t_Server) u8)
          (Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_AppData & t_Server) u8)
      | _ ->
        Core.Ops.Control_flow.ControlFlow_Continue
        (Core.Result.Result_Err Bertie.Tls13utils.v_INCORRECT_STATE
          <:
          Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_AppData & t_Server) u8)
        <:
        Core.Ops.Control_flow.t_ControlFlow
          (Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_AppData & t_Server) u8)
          (Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_AppData & t_Server) u8))

let server_write (d: Bertie.Tls13utils.t_AppData) (st: t_Server)
    : Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & t_Server) u8 =
  Rust_primitives.Hax.Control_flow_monad.Mexception.run (match st with
      | Server_Server1 sstate cipher1 ->
        let* v_by, cipher1:(Bertie.Tls13utils.t_Bytes & Bertie.Tls13record.t_DuplexCipherState1) =
          match
            Core.Ops.Try_trait.f_branch (Bertie.Tls13record.encrypt_data d (sz 0) cipher1
                <:
                Core.Result.t_Result
                  (Bertie.Tls13utils.t_Bytes & Bertie.Tls13record.t_DuplexCipherState1) u8)
          with
          | Core.Ops.Control_flow.ControlFlow_Break residual ->
            let* hoist469:Rust_primitives.Hax.t_Never =
              Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                  <:
                  Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & t_Server) u8)
            in
            Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist469)
            <:
            Core.Ops.Control_flow.t_ControlFlow
              (Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & t_Server) u8)
              (Bertie.Tls13utils.t_Bytes & Bertie.Tls13record.t_DuplexCipherState1)
          | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
            Core.Ops.Control_flow.ControlFlow_Continue v_val
            <:
            Core.Ops.Control_flow.t_ControlFlow
              (Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & t_Server) u8)
              (Bertie.Tls13utils.t_Bytes & Bertie.Tls13record.t_DuplexCipherState1)
        in
        Core.Ops.Control_flow.ControlFlow_Continue
        (Core.Result.Result_Ok
          (v_by, (Server_Server1 sstate cipher1 <: t_Server)
            <:
            (Bertie.Tls13utils.t_Bytes & t_Server))
          <:
          Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & t_Server) u8)
        <:
        Core.Ops.Control_flow.t_ControlFlow
          (Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & t_Server) u8)
          (Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & t_Server) u8)
      | _ ->
        Core.Ops.Control_flow.ControlFlow_Continue
        (Core.Result.Result_Err Bertie.Tls13utils.v_INCORRECT_STATE
          <:
          Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & t_Server) u8)
        <:
        Core.Ops.Control_flow.t_ControlFlow
          (Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & t_Server) u8)
          (Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & t_Server) u8))

let in_psk_mode (c: t_Client) : bool =
  match c with
  | Client_Client0 cstate _ ->
    Bertie.Tls13crypto.impl__Algorithms__psk_mode (Bertie.Tls13handshake.algs_post_client_hello cstate

        <:
        Bertie.Tls13crypto.t_Algorithms)
  | Client_ClientH cstate _ _ _ ->
    Bertie.Tls13crypto.impl__Algorithms__psk_mode (Bertie.Tls13handshake.algs_post_server_hello cstate

        <:
        Bertie.Tls13crypto.t_Algorithms)
  | Client_Client1 cstate _ ->
    Bertie.Tls13crypto.impl__Algorithms__psk_mode (Bertie.Tls13handshake.algs_post_client_finished cstate

        <:
        Bertie.Tls13crypto.t_Algorithms)

let impl__Client__connect
      (ciphersuite: Bertie.Tls13crypto.t_Algorithms)
      (server_name: Bertie.Tls13utils.t_Bytes)
      (session_ticket psk: Core.Option.t_Option Bertie.Tls13utils.t_Bytes)
      (entropy: Bertie.Tls13utils.t_Bytes)
    : Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & t_Client) u8 =
  Rust_primitives.Hax.Control_flow_monad.Mexception.run (let* ch, cipher0, cstate:(Bertie.Tls13utils.t_HandshakeData &
        Core.Option.t_Option Bertie.Tls13record.t_ClientCipherState0 &
        Bertie.Tls13handshake.t_ClientPostClientHello) =
        match
          Core.Ops.Try_trait.f_branch (Bertie.Tls13handshake.client_init ciphersuite
                server_name
                session_ticket
                psk
                entropy
              <:
              Core.Result.t_Result
                (Bertie.Tls13utils.t_HandshakeData &
                  Core.Option.t_Option Bertie.Tls13record.t_ClientCipherState0 &
                  Bertie.Tls13handshake.t_ClientPostClientHello) u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist478:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & t_Client) u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist478)
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & t_Client) u8)
            (Bertie.Tls13utils.t_HandshakeData &
              Core.Option.t_Option Bertie.Tls13record.t_ClientCipherState0 &
              Bertie.Tls13handshake.t_ClientPostClientHello)
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & t_Client) u8)
            (Bertie.Tls13utils.t_HandshakeData &
              Core.Option.t_Option Bertie.Tls13record.t_ClientCipherState0 &
              Bertie.Tls13handshake.t_ClientPostClientHello)
      in
      let* client_hello:Bertie.Tls13utils.t_Bytes =
        match
          Core.Ops.Try_trait.f_branch (Bertie.Tls13formats.handshake_record ch
              <:
              Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist479:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & t_Client) u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist479)
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & t_Client) u8)
            Bertie.Tls13utils.t_Bytes
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & t_Client) u8)
            Bertie.Tls13utils.t_Bytes
      in
      Core.Ops.Control_flow.ControlFlow_Continue
      (let client_hello:Bertie.Tls13utils.t_Bytes =
          Rust_primitives.Hax.update_at client_hello
            (sz 2)
            (Core.Convert.f_from 1uy <: Bertie.Tls13utils.t_U8)
        in
        Core.Result.Result_Ok
        (client_hello, Bertie.Tls13api.Client.v_Client0 cstate cipher0
          <:
          (Bertie.Tls13utils.t_Bytes & t_Client))
        <:
        Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & t_Client) u8)
      <:
      Core.Ops.Control_flow.t_ControlFlow
        (Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & t_Client) u8)
        (Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & t_Client) u8))

let impl__Client__read_handshake (self: t_Client) (handshake_bytes: Bertie.Tls13utils.t_Bytes)
    : Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_Bytes & t_Client) u8 =
  Rust_primitives.Hax.Control_flow_monad.Mexception.run (match self with
      | Client_Client0 state cipher_state ->
        let* sf:Bertie.Tls13utils.t_HandshakeData =
          match
            Core.Ops.Try_trait.f_branch (Bertie.Tls13formats.get_handshake_record handshake_bytes
                <:
                Core.Result.t_Result Bertie.Tls13utils.t_HandshakeData u8)
          with
          | Core.Ops.Control_flow.ControlFlow_Break residual ->
            let* hoist533:Rust_primitives.Hax.t_Never =
              Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                  <:
                  Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_Bytes & t_Client)
                    u8)
            in
            Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist533)
            <:
            Core.Ops.Control_flow.t_ControlFlow
              (Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_Bytes & t_Client) u8)
              Bertie.Tls13utils.t_HandshakeData
          | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
            Core.Ops.Control_flow.ControlFlow_Continue v_val
            <:
            Core.Ops.Control_flow.t_ControlFlow
              (Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_Bytes & t_Client) u8)
              Bertie.Tls13utils.t_HandshakeData
        in
        let* cipher1, cstate:(Bertie.Tls13record.t_DuplexCipherStateH &
          Bertie.Tls13handshake.t_ClientPostServerHello) =
          match
            Core.Ops.Try_trait.f_branch (Bertie.Tls13handshake.client_set_params sf state
                <:
                Core.Result.t_Result
                  (Bertie.Tls13record.t_DuplexCipherStateH &
                    Bertie.Tls13handshake.t_ClientPostServerHello) u8)
          with
          | Core.Ops.Control_flow.ControlFlow_Break residual ->
            let* hoist534:Rust_primitives.Hax.t_Never =
              Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                  <:
                  Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_Bytes & t_Client)
                    u8)
            in
            Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist534)
            <:
            Core.Ops.Control_flow.t_ControlFlow
              (Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_Bytes & t_Client) u8)
              (Bertie.Tls13record.t_DuplexCipherStateH &
                Bertie.Tls13handshake.t_ClientPostServerHello)
          | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
            Core.Ops.Control_flow.ControlFlow_Continue v_val
            <:
            Core.Ops.Control_flow.t_ControlFlow
              (Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_Bytes & t_Client) u8)
              (Bertie.Tls13record.t_DuplexCipherStateH &
                Bertie.Tls13handshake.t_ClientPostServerHello)
        in
        Core.Ops.Control_flow.ControlFlow_Continue
        (let buf:Bertie.Tls13utils.t_HandshakeData =
            Bertie.Tls13utils.handshake_data (Bertie.Tls13utils.impl__Bytes__new
                <:
                Bertie.Tls13utils.t_Bytes)
          in
          Core.Result.Result_Ok
          ((Core.Option.Option_None <: Core.Option.t_Option Bertie.Tls13utils.t_Bytes),
            Bertie.Tls13api.Client.v_ClientH cstate cipher_state cipher1 buf
            <:
            (Core.Option.t_Option Bertie.Tls13utils.t_Bytes & t_Client))
          <:
          Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_Bytes & t_Client) u8)
        <:
        Core.Ops.Control_flow.t_ControlFlow
          (Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_Bytes & t_Client) u8)
          (Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_Bytes & t_Client) u8)
      | Client_ClientH cstate cipher0 cipher_hs buf ->
        let* hd, cipher_hs:(Bertie.Tls13utils.t_HandshakeData &
          Bertie.Tls13record.t_DuplexCipherStateH) =
          match
            Core.Ops.Try_trait.f_branch (Bertie.Tls13record.decrypt_handshake handshake_bytes
                  cipher_hs
                <:
                Core.Result.t_Result
                  (Bertie.Tls13utils.t_HandshakeData & Bertie.Tls13record.t_DuplexCipherStateH) u8)
          with
          | Core.Ops.Control_flow.ControlFlow_Break residual ->
            let* hoist535:Rust_primitives.Hax.t_Never =
              Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                  <:
                  Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_Bytes & t_Client)
                    u8)
            in
            Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist535)
            <:
            Core.Ops.Control_flow.t_ControlFlow
              (Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_Bytes & t_Client) u8)
              (Bertie.Tls13utils.t_HandshakeData & Bertie.Tls13record.t_DuplexCipherStateH)
          | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
            Core.Ops.Control_flow.ControlFlow_Continue v_val
            <:
            Core.Ops.Control_flow.t_ControlFlow
              (Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_Bytes & t_Client) u8)
              (Bertie.Tls13utils.t_HandshakeData & Bertie.Tls13record.t_DuplexCipherStateH)
        in
        let buf:Bertie.Tls13utils.t_HandshakeData = Bertie.Tls13utils.handshake_concat buf hd in
        if
          Bertie.Tls13formats.find_handshake_message (Bertie.Tls13formats.HandshakeType_Finished
              <:
              Bertie.Tls13formats.t_HandshakeType)
            buf
            (sz 0)
        then
          let* cfin, cipher1, cstate:(Bertie.Tls13utils.t_HandshakeData &
            Bertie.Tls13record.t_DuplexCipherState1 &
            Bertie.Tls13handshake.t_ClientPostClientFinished) =
            match
              Core.Ops.Try_trait.f_branch (Bertie.Tls13handshake.client_finish buf cstate
                  <:
                  Core.Result.t_Result
                    (Bertie.Tls13utils.t_HandshakeData & Bertie.Tls13record.t_DuplexCipherState1 &
                      Bertie.Tls13handshake.t_ClientPostClientFinished) u8)
            with
            | Core.Ops.Control_flow.ControlFlow_Break residual ->
              let* hoist536:Rust_primitives.Hax.t_Never =
                Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual

                    <:
                    Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_Bytes & t_Client)
                      u8)
              in
              Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist536)
              <:
              Core.Ops.Control_flow.t_ControlFlow
                (Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_Bytes & t_Client) u8
                )
                (Bertie.Tls13utils.t_HandshakeData & Bertie.Tls13record.t_DuplexCipherState1 &
                  Bertie.Tls13handshake.t_ClientPostClientFinished)
            | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
              Core.Ops.Control_flow.ControlFlow_Continue v_val
              <:
              Core.Ops.Control_flow.t_ControlFlow
                (Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_Bytes & t_Client) u8
                )
                (Bertie.Tls13utils.t_HandshakeData & Bertie.Tls13record.t_DuplexCipherState1 &
                  Bertie.Tls13handshake.t_ClientPostClientFinished)
          in
          let* cf_rec, v__cipher_hs:(Bertie.Tls13utils.t_Bytes &
            Bertie.Tls13record.t_DuplexCipherStateH) =
            match
              Core.Ops.Try_trait.f_branch (Bertie.Tls13record.encrypt_handshake cfin
                    (sz 0)
                    cipher_hs
                  <:
                  Core.Result.t_Result
                    (Bertie.Tls13utils.t_Bytes & Bertie.Tls13record.t_DuplexCipherStateH) u8)
            with
            | Core.Ops.Control_flow.ControlFlow_Break residual ->
              let* hoist537:Rust_primitives.Hax.t_Never =
                Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual

                    <:
                    Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_Bytes & t_Client)
                      u8)
              in
              Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist537)
              <:
              Core.Ops.Control_flow.t_ControlFlow
                (Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_Bytes & t_Client) u8
                ) (Bertie.Tls13utils.t_Bytes & Bertie.Tls13record.t_DuplexCipherStateH)
            | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
              Core.Ops.Control_flow.ControlFlow_Continue v_val
              <:
              Core.Ops.Control_flow.t_ControlFlow
                (Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_Bytes & t_Client) u8
                ) (Bertie.Tls13utils.t_Bytes & Bertie.Tls13record.t_DuplexCipherStateH)
          in
          Core.Ops.Control_flow.ControlFlow_Continue
          (Core.Result.Result_Ok
            ((Core.Option.Option_Some cf_rec <: Core.Option.t_Option Bertie.Tls13utils.t_Bytes),
              Bertie.Tls13api.Client.v_Client1 cstate cipher1
              <:
              (Core.Option.t_Option Bertie.Tls13utils.t_Bytes & t_Client))
            <:
            Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_Bytes & t_Client) u8)
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_Bytes & t_Client) u8)
            (Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_Bytes & t_Client) u8)
        else
          Core.Ops.Control_flow.ControlFlow_Continue
          (Core.Result.Result_Ok
            ((Core.Option.Option_None <: Core.Option.t_Option Bertie.Tls13utils.t_Bytes),
              Bertie.Tls13api.Client.v_ClientH cstate cipher0 cipher_hs buf
              <:
              (Core.Option.t_Option Bertie.Tls13utils.t_Bytes & t_Client))
            <:
            Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_Bytes & t_Client) u8)
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_Bytes & t_Client) u8)
            (Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_Bytes & t_Client) u8)
      | _ ->
        Core.Ops.Control_flow.ControlFlow_Continue
        (Core.Result.Result_Err Bertie.Tls13utils.v_INCORRECT_STATE
          <:
          Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_Bytes & t_Client) u8)
        <:
        Core.Ops.Control_flow.t_ControlFlow
          (Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_Bytes & t_Client) u8)
          (Core.Result.t_Result (Core.Option.t_Option Bertie.Tls13utils.t_Bytes & t_Client) u8))

let server_read_handshake (cfin_rec: Bertie.Tls13utils.t_Bytes) (st: t_Server)
    : Core.Result.t_Result t_Server u8 =
  Rust_primitives.Hax.Control_flow_monad.Mexception.run (match st with
      | Server_ServerH sstate v__cipher0 cipher_hs cipher1 ->
        let* cf, v__cipher_hs:(Bertie.Tls13utils.t_HandshakeData &
          Bertie.Tls13record.t_DuplexCipherStateH) =
          match
            Core.Ops.Try_trait.f_branch (Bertie.Tls13record.decrypt_handshake cfin_rec cipher_hs
                <:
                Core.Result.t_Result
                  (Bertie.Tls13utils.t_HandshakeData & Bertie.Tls13record.t_DuplexCipherStateH) u8)
          with
          | Core.Ops.Control_flow.ControlFlow_Break residual ->
            let* hoist538:Rust_primitives.Hax.t_Never =
              Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                  <:
                  Core.Result.t_Result t_Server u8)
            in
            Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist538)
            <:
            Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result t_Server u8)
              (Bertie.Tls13utils.t_HandshakeData & Bertie.Tls13record.t_DuplexCipherStateH)
          | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
            Core.Ops.Control_flow.ControlFlow_Continue v_val
            <:
            Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result t_Server u8)
              (Bertie.Tls13utils.t_HandshakeData & Bertie.Tls13record.t_DuplexCipherStateH)
        in
        let* sstate:Bertie.Tls13handshake.t_ServerPostClientFinished =
          match
            Core.Ops.Try_trait.f_branch (Bertie.Tls13handshake.server_finish cf sstate
                <:
                Core.Result.t_Result Bertie.Tls13handshake.t_ServerPostClientFinished u8)
          with
          | Core.Ops.Control_flow.ControlFlow_Break residual ->
            let* hoist539:Rust_primitives.Hax.t_Never =
              Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                  <:
                  Core.Result.t_Result t_Server u8)
            in
            Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist539)
            <:
            Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result t_Server u8)
              Bertie.Tls13handshake.t_ServerPostClientFinished
          | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
            Core.Ops.Control_flow.ControlFlow_Continue v_val
            <:
            Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result t_Server u8)
              Bertie.Tls13handshake.t_ServerPostClientFinished
        in
        Core.Ops.Control_flow.ControlFlow_Continue
        (Core.Result.Result_Ok (Server_Server1 sstate cipher1 <: t_Server)
          <:
          Core.Result.t_Result t_Server u8)
        <:
        Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result t_Server u8)
          (Core.Result.t_Result t_Server u8)
      | _ ->
        Core.Ops.Control_flow.ControlFlow_Continue
        (Core.Result.Result_Err Bertie.Tls13utils.v_INCORRECT_STATE
          <:
          Core.Result.t_Result t_Server u8)
        <:
        Core.Ops.Control_flow.t_ControlFlow (Core.Result.t_Result t_Server u8)
          (Core.Result.t_Result t_Server u8))

let server_accept
      (algs: Bertie.Tls13crypto.t_Algorithms)
      (db: Bertie.Server.t_ServerDB)
      (ch_rec ent: Bertie.Tls13utils.t_Bytes)
    : Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & Bertie.Tls13utils.t_Bytes & t_Server) u8 =
  Rust_primitives.Hax.Control_flow_monad.Mexception.run (let ch_rec:Bertie.Tls13utils.t_Bytes =
        Core.Clone.f_clone ch_rec
      in
      let ch_rec:Bertie.Tls13utils.t_Bytes =
        Rust_primitives.Hax.update_at ch_rec
          (sz 2)
          (Core.Convert.f_from 3uy <: Bertie.Tls13utils.t_U8)
      in
      let* ch:Bertie.Tls13utils.t_HandshakeData =
        match
          Core.Ops.Try_trait.f_branch (Bertie.Tls13formats.get_handshake_record ch_rec
              <:
              Core.Result.t_Result Bertie.Tls13utils.t_HandshakeData u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist546:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result
                  (Bertie.Tls13utils.t_Bytes & Bertie.Tls13utils.t_Bytes & t_Server) u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist546)
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & Bertie.Tls13utils.t_Bytes & t_Server)
                u8) Bertie.Tls13utils.t_HandshakeData
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & Bertie.Tls13utils.t_Bytes & t_Server)
                u8) Bertie.Tls13utils.t_HandshakeData
      in
      let* sh, sf, cipher0, cipher_hs, cipher1, sstate:(Bertie.Tls13utils.t_HandshakeData &
        Bertie.Tls13utils.t_HandshakeData &
        Core.Option.t_Option Bertie.Tls13record.t_ServerCipherState0 &
        Bertie.Tls13record.t_DuplexCipherStateH &
        Bertie.Tls13record.t_DuplexCipherState1 &
        Bertie.Tls13handshake.t_ServerPostServerFinished) =
        match
          Core.Ops.Try_trait.f_branch (Bertie.Tls13handshake.server_init algs ch db ent
              <:
              Core.Result.t_Result
                (Bertie.Tls13utils.t_HandshakeData & Bertie.Tls13utils.t_HandshakeData &
                  Core.Option.t_Option Bertie.Tls13record.t_ServerCipherState0 &
                  Bertie.Tls13record.t_DuplexCipherStateH &
                  Bertie.Tls13record.t_DuplexCipherState1 &
                  Bertie.Tls13handshake.t_ServerPostServerFinished) u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist547:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result
                  (Bertie.Tls13utils.t_Bytes & Bertie.Tls13utils.t_Bytes & t_Server) u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist547)
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & Bertie.Tls13utils.t_Bytes & t_Server)
                u8)
            (Bertie.Tls13utils.t_HandshakeData & Bertie.Tls13utils.t_HandshakeData &
              Core.Option.t_Option Bertie.Tls13record.t_ServerCipherState0 &
              Bertie.Tls13record.t_DuplexCipherStateH &
              Bertie.Tls13record.t_DuplexCipherState1 &
              Bertie.Tls13handshake.t_ServerPostServerFinished)
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & Bertie.Tls13utils.t_Bytes & t_Server)
                u8)
            (Bertie.Tls13utils.t_HandshakeData & Bertie.Tls13utils.t_HandshakeData &
              Core.Option.t_Option Bertie.Tls13record.t_ServerCipherState0 &
              Bertie.Tls13record.t_DuplexCipherStateH &
              Bertie.Tls13record.t_DuplexCipherState1 &
              Bertie.Tls13handshake.t_ServerPostServerFinished)
      in
      let* sh_rec:Bertie.Tls13utils.t_Bytes =
        match
          Core.Ops.Try_trait.f_branch (Bertie.Tls13formats.handshake_record sh
              <:
              Core.Result.t_Result Bertie.Tls13utils.t_Bytes u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist548:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result
                  (Bertie.Tls13utils.t_Bytes & Bertie.Tls13utils.t_Bytes & t_Server) u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist548)
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & Bertie.Tls13utils.t_Bytes & t_Server)
                u8) Bertie.Tls13utils.t_Bytes
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & Bertie.Tls13utils.t_Bytes & t_Server)
                u8) Bertie.Tls13utils.t_Bytes
      in
      let* sf_rec, cipher_hs:(Bertie.Tls13utils.t_Bytes & Bertie.Tls13record.t_DuplexCipherStateH) =
        match
          Core.Ops.Try_trait.f_branch (Bertie.Tls13record.encrypt_handshake sf (sz 0) cipher_hs
              <:
              Core.Result.t_Result
                (Bertie.Tls13utils.t_Bytes & Bertie.Tls13record.t_DuplexCipherStateH) u8)
        with
        | Core.Ops.Control_flow.ControlFlow_Break residual ->
          let* hoist549:Rust_primitives.Hax.t_Never =
            Core.Ops.Control_flow.ControlFlow.v_Break (Core.Ops.Try_trait.f_from_residual residual
                <:
                Core.Result.t_Result
                  (Bertie.Tls13utils.t_Bytes & Bertie.Tls13utils.t_Bytes & t_Server) u8)
          in
          Core.Ops.Control_flow.ControlFlow_Continue (Rust_primitives.Hax.never_to_any hoist549)
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & Bertie.Tls13utils.t_Bytes & t_Server)
                u8) (Bertie.Tls13utils.t_Bytes & Bertie.Tls13record.t_DuplexCipherStateH)
        | Core.Ops.Control_flow.ControlFlow_Continue v_val ->
          Core.Ops.Control_flow.ControlFlow_Continue v_val
          <:
          Core.Ops.Control_flow.t_ControlFlow
            (Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & Bertie.Tls13utils.t_Bytes & t_Server)
                u8) (Bertie.Tls13utils.t_Bytes & Bertie.Tls13record.t_DuplexCipherStateH)
      in
      Core.Ops.Control_flow.ControlFlow_Continue
      (Core.Result.Result_Ok
        (sh_rec, sf_rec, (Server_ServerH sstate cipher0 cipher_hs cipher1 <: t_Server)
          <:
          (Bertie.Tls13utils.t_Bytes & Bertie.Tls13utils.t_Bytes & t_Server))
        <:
        Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & Bertie.Tls13utils.t_Bytes & t_Server) u8)
      <:
      Core.Ops.Control_flow.t_ControlFlow
        (Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & Bertie.Tls13utils.t_Bytes & t_Server) u8)
        (Core.Result.t_Result (Bertie.Tls13utils.t_Bytes & Bertie.Tls13utils.t_Bytes & t_Server) u8)
    )