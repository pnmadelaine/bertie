#![allow(non_upper_case_globals, clippy::zero_prefixed_literal)]

// Import hacspec and all needed definitions.
use std::io::prelude::*;

use bertie::{tls13api::*, tls13crypto::*, tls13utils::*, ServerDB};

use rand::*;
pub use record::AppError;
use record::RecordStream;

#[allow(dead_code)]
const SHA256_Aes128Gcm_EcdsaSecp256r1Sha256_X25519: Algorithms = Algorithms(
    HashAlgorithm::SHA256,
    AeadAlgorithm::Aes128Gcm,
    SignatureScheme::EcdsaSecp256r1Sha256,
    KemScheme::X25519,
    false,
    false,
);

#[allow(dead_code)]
const SHA256_Aes128Gcm_EcdsaSecp256r1Sha256_P256: Algorithms = Algorithms(
    HashAlgorithm::SHA256,
    AeadAlgorithm::Aes128Gcm,
    SignatureScheme::EcdsaSecp256r1Sha256,
    KemScheme::Secp256r1,
    false,
    false,
);

const SHA256_Chacha20Poly1305_EcdsaSecp256r1Sha256_X25519: Algorithms = Algorithms(
    HashAlgorithm::SHA256,
    AeadAlgorithm::Chacha20Poly1305,
    SignatureScheme::EcdsaSecp256r1Sha256,
    KemScheme::X25519,
    false,
    false,
);

#[allow(dead_code)]
const SHA256_Chacha20Poly1305_RsaPssRsaSha256_X25519: Algorithms = Algorithms(
    HashAlgorithm::SHA256,
    AeadAlgorithm::Chacha20Poly1305,
    SignatureScheme::RsaPssRsaSha256,
    KemScheme::X25519,
    false,
    false,
);

const default_algs: Algorithms = SHA256_Chacha20Poly1305_EcdsaSecp256r1Sha256_X25519;

// Cert and Key
const ECDSA_P256_SHA256_CERT: [u8; 522] = [
    0x30, 0x82, 0x02, 0x06, 0x30, 0x82, 0x01, 0xAC, 0x02, 0x09, 0x00, 0xD1, 0xA2, 0xE4, 0xD5, 0x78,
    0x05, 0x08, 0x61, 0x30, 0x0A, 0x06, 0x08, 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x04, 0x03, 0x02, 0x30,
    0x81, 0x8A, 0x31, 0x0B, 0x30, 0x09, 0x06, 0x03, 0x55, 0x04, 0x06, 0x13, 0x02, 0x44, 0x45, 0x31,
    0x0F, 0x30, 0x0D, 0x06, 0x03, 0x55, 0x04, 0x08, 0x0C, 0x06, 0x42, 0x65, 0x72, 0x6C, 0x69, 0x6E,
    0x31, 0x0F, 0x30, 0x0D, 0x06, 0x03, 0x55, 0x04, 0x07, 0x0C, 0x06, 0x42, 0x65, 0x72, 0x6C, 0x69,
    0x6E, 0x31, 0x10, 0x30, 0x0E, 0x06, 0x03, 0x55, 0x04, 0x0A, 0x0C, 0x07, 0x68, 0x61, 0x63, 0x73,
    0x70, 0x65, 0x63, 0x31, 0x0F, 0x30, 0x0D, 0x06, 0x03, 0x55, 0x04, 0x0B, 0x0C, 0x06, 0x62, 0x65,
    0x72, 0x74, 0x69, 0x65, 0x31, 0x17, 0x30, 0x15, 0x06, 0x03, 0x55, 0x04, 0x03, 0x0C, 0x0E, 0x62,
    0x65, 0x72, 0x74, 0x69, 0x65, 0x2E, 0x68, 0x61, 0x63, 0x73, 0x70, 0x65, 0x63, 0x31, 0x1D, 0x30,
    0x1B, 0x06, 0x09, 0x2A, 0x86, 0x48, 0x86, 0xF7, 0x0D, 0x01, 0x09, 0x01, 0x16, 0x0E, 0x62, 0x65,
    0x72, 0x74, 0x69, 0x65, 0x40, 0x68, 0x61, 0x63, 0x73, 0x70, 0x65, 0x63, 0x30, 0x1E, 0x17, 0x0D,
    0x32, 0x31, 0x30, 0x34, 0x32, 0x39, 0x31, 0x31, 0x34, 0x37, 0x34, 0x35, 0x5A, 0x17, 0x0D, 0x33,
    0x31, 0x30, 0x34, 0x32, 0x37, 0x31, 0x31, 0x34, 0x37, 0x34, 0x35, 0x5A, 0x30, 0x81, 0x8A, 0x31,
    0x0B, 0x30, 0x09, 0x06, 0x03, 0x55, 0x04, 0x06, 0x13, 0x02, 0x44, 0x45, 0x31, 0x0F, 0x30, 0x0D,
    0x06, 0x03, 0x55, 0x04, 0x08, 0x0C, 0x06, 0x42, 0x65, 0x72, 0x6C, 0x69, 0x6E, 0x31, 0x0F, 0x30,
    0x0D, 0x06, 0x03, 0x55, 0x04, 0x07, 0x0C, 0x06, 0x42, 0x65, 0x72, 0x6C, 0x69, 0x6E, 0x31, 0x10,
    0x30, 0x0E, 0x06, 0x03, 0x55, 0x04, 0x0A, 0x0C, 0x07, 0x68, 0x61, 0x63, 0x73, 0x70, 0x65, 0x63,
    0x31, 0x0F, 0x30, 0x0D, 0x06, 0x03, 0x55, 0x04, 0x0B, 0x0C, 0x06, 0x62, 0x65, 0x72, 0x74, 0x69,
    0x65, 0x31, 0x17, 0x30, 0x15, 0x06, 0x03, 0x55, 0x04, 0x03, 0x0C, 0x0E, 0x62, 0x65, 0x72, 0x74,
    0x69, 0x65, 0x2E, 0x68, 0x61, 0x63, 0x73, 0x70, 0x65, 0x63, 0x31, 0x1D, 0x30, 0x1B, 0x06, 0x09,
    0x2A, 0x86, 0x48, 0x86, 0xF7, 0x0D, 0x01, 0x09, 0x01, 0x16, 0x0E, 0x62, 0x65, 0x72, 0x74, 0x69,
    0x65, 0x40, 0x68, 0x61, 0x63, 0x73, 0x70, 0x65, 0x63, 0x30, 0x59, 0x30, 0x13, 0x06, 0x07, 0x2A,
    0x86, 0x48, 0xCE, 0x3D, 0x02, 0x01, 0x06, 0x08, 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x03, 0x01, 0x07,
    0x03, 0x42, 0x00, 0x04, 0xD8, 0xE0, 0x74, 0xF7, 0xCB, 0xEF, 0x19, 0xC7, 0x56, 0xA4, 0x52, 0x59,
    0x0C, 0x02, 0x70, 0xCC, 0x9B, 0xFC, 0x45, 0x8D, 0x73, 0x28, 0x39, 0x1D, 0x3B, 0xF5, 0x26, 0x17,
    0x8B, 0x0D, 0x25, 0x04, 0x91, 0xE8, 0xC8, 0x72, 0x22, 0x59, 0x9A, 0x2C, 0xBB, 0x26, 0x31, 0xB1,
    0xCC, 0x6B, 0x6F, 0x5A, 0x10, 0xD9, 0x7D, 0xD7, 0x86, 0x56, 0xFB, 0x89, 0x39, 0x9E, 0x0A, 0x91,
    0x9F, 0x35, 0x81, 0xE7, 0x30, 0x0A, 0x06, 0x08, 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x04, 0x03, 0x02,
    0x03, 0x48, 0x00, 0x30, 0x45, 0x02, 0x21, 0x00, 0xA1, 0x81, 0xB3, 0xD6, 0x8C, 0x9F, 0x62, 0x66,
    0xC6, 0xB7, 0x3F, 0x26, 0xE7, 0xFD, 0x88, 0xF9, 0x4B, 0xD8, 0x15, 0xD1, 0x45, 0xC7, 0x66, 0x69,
    0x40, 0xC2, 0x55, 0x21, 0x84, 0x9F, 0xE6, 0x8C, 0x02, 0x20, 0x10, 0x7E, 0xEF, 0xF3, 0x1D, 0x58,
    0x32, 0x6E, 0xF7, 0xCB, 0x0A, 0x47, 0xF2, 0xBA, 0xEB, 0xBC, 0xB7, 0x8F, 0x46, 0x56, 0xF1, 0x5B,
    0xCC, 0x2E, 0xD5, 0xB3, 0xC4, 0x0F, 0x5B, 0x22, 0xBD, 0x02,
];
const ECDSA_P256_SHA256_Key: [u8; 32] = [
    0xA6, 0xDE, 0x48, 0x21, 0x0E, 0x56, 0x12, 0xDD, 0x95, 0x3A, 0x91, 0x4E, 0x9F, 0x56, 0xC3, 0xA2,
    0xDB, 0x7A, 0x36, 0x20, 0x08, 0xE9, 0x52, 0xEE, 0xDB, 0xCE, 0xAC, 0x3B, 0x26, 0xF9, 0x20, 0xBD,
];

const RSA_PSS_RSAE_SHA256_CERT: [u8; 879] = [
    0x30, 0x82, 0x03, 0x6b, 0x30, 0x82, 0x02, 0x53, 0xa0, 0x03, 0x02, 0x01, 0x02, 0x02, 0x14, 0x20,
    0x73, 0x1d, 0x52, 0x56, 0x7a, 0x3d, 0xa3, 0x7a, 0x76, 0xcf, 0xb6, 0x8d, 0xb6, 0x0c, 0xd3, 0x50,
    0xac, 0x99, 0x2f, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01, 0x0b,
    0x05, 0x00, 0x30, 0x45, 0x31, 0x0b, 0x30, 0x09, 0x06, 0x03, 0x55, 0x04, 0x06, 0x13, 0x02, 0x41,
    0x55, 0x31, 0x13, 0x30, 0x11, 0x06, 0x03, 0x55, 0x04, 0x08, 0x0c, 0x0a, 0x53, 0x6f, 0x6d, 0x65,
    0x2d, 0x53, 0x74, 0x61, 0x74, 0x65, 0x31, 0x21, 0x30, 0x1f, 0x06, 0x03, 0x55, 0x04, 0x0a, 0x0c,
    0x18, 0x49, 0x6e, 0x74, 0x65, 0x72, 0x6e, 0x65, 0x74, 0x20, 0x57, 0x69, 0x64, 0x67, 0x69, 0x74,
    0x73, 0x20, 0x50, 0x74, 0x79, 0x20, 0x4c, 0x74, 0x64, 0x30, 0x1e, 0x17, 0x0d, 0x32, 0x33, 0x31,
    0x31, 0x31, 0x36, 0x31, 0x33, 0x33, 0x36, 0x35, 0x30, 0x5a, 0x17, 0x0d, 0x32, 0x34, 0x31, 0x31,
    0x31, 0x35, 0x31, 0x33, 0x33, 0x36, 0x35, 0x30, 0x5a, 0x30, 0x45, 0x31, 0x0b, 0x30, 0x09, 0x06,
    0x03, 0x55, 0x04, 0x06, 0x13, 0x02, 0x41, 0x55, 0x31, 0x13, 0x30, 0x11, 0x06, 0x03, 0x55, 0x04,
    0x08, 0x0c, 0x0a, 0x53, 0x6f, 0x6d, 0x65, 0x2d, 0x53, 0x74, 0x61, 0x74, 0x65, 0x31, 0x21, 0x30,
    0x1f, 0x06, 0x03, 0x55, 0x04, 0x0a, 0x0c, 0x18, 0x49, 0x6e, 0x74, 0x65, 0x72, 0x6e, 0x65, 0x74,
    0x20, 0x57, 0x69, 0x64, 0x67, 0x69, 0x74, 0x73, 0x20, 0x50, 0x74, 0x79, 0x20, 0x4c, 0x74, 0x64,
    0x30, 0x82, 0x01, 0x22, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01,
    0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x0f, 0x00, 0x30, 0x82, 0x01, 0x0a, 0x02, 0x82, 0x01, 0x01,
    0x00, 0xad, 0xf1, 0xd1, 0x26, 0x1b, 0x4c, 0x3a, 0xe2, 0x24, 0xfa, 0x58, 0x6f, 0xbd, 0xde, 0x2e,
    0x61, 0x77, 0xcb, 0x50, 0x5d, 0xac, 0x15, 0x67, 0xef, 0xbc, 0x39, 0x49, 0x84, 0xab, 0x3b, 0xc7,
    0x66, 0x36, 0x25, 0xb6, 0xc4, 0xcf, 0xac, 0x99, 0xf3, 0x0c, 0x7d, 0x9a, 0x26, 0xd3, 0x86, 0xc3,
    0x42, 0x36, 0x91, 0xbd, 0x75, 0x6f, 0xba, 0x70, 0x9a, 0xec, 0xb7, 0xd9, 0x40, 0xce, 0xd2, 0x1e,
    0xcd, 0xec, 0x81, 0x58, 0x82, 0x8d, 0x21, 0xba, 0x13, 0x28, 0x64, 0xb4, 0x8c, 0x9c, 0x18, 0xa3,
    0xc9, 0x28, 0x1a, 0xf5, 0x79, 0x99, 0x1c, 0x90, 0x19, 0xe2, 0x2e, 0x12, 0xfc, 0x25, 0xd7, 0x7d,
    0x87, 0x30, 0xa4, 0x03, 0x75, 0x1e, 0x7e, 0x29, 0x48, 0xcb, 0x89, 0xa6, 0x56, 0x37, 0xb7, 0xf8,
    0xb6, 0x13, 0xfb, 0x68, 0x52, 0xf1, 0x33, 0xae, 0x80, 0x5a, 0x38, 0x1d, 0x57, 0x7c, 0x24, 0x46,
    0x07, 0xb9, 0xf2, 0x23, 0xe1, 0x40, 0x5d, 0x5d, 0x8e, 0xe0, 0x24, 0x9b, 0xbc, 0xbb, 0xf6, 0x75,
    0x9b, 0xca, 0x75, 0x3b, 0x9a, 0x03, 0x64, 0x70, 0xab, 0xb4, 0xdf, 0xd8, 0x59, 0xef, 0xbc, 0x80,
    0xb6, 0x1e, 0x70, 0x65, 0x9f, 0x1f, 0xbe, 0xee, 0x3f, 0x1f, 0xb1, 0xc8, 0x46, 0xe8, 0x86, 0x63,
    0x43, 0x45, 0x2f, 0xab, 0x04, 0x66, 0x04, 0x3c, 0x16, 0x84, 0x7f, 0x29, 0x63, 0x65, 0xae, 0xd8,
    0xaa, 0xaf, 0xa9, 0x9a, 0xbb, 0x72, 0xdb, 0x62, 0xa4, 0xc8, 0x78, 0xe2, 0x40, 0x71, 0x08, 0xcd,
    0x62, 0xbe, 0x56, 0x8f, 0xf6, 0xc2, 0xce, 0x09, 0x7a, 0xeb, 0xb3, 0x37, 0x47, 0x14, 0xdd, 0xc1,
    0x4e, 0x01, 0xdf, 0xec, 0xdd, 0xc4, 0x87, 0x51, 0x8a, 0xb2, 0xee, 0xdf, 0x2d, 0x39, 0xd0, 0x39,
    0x0f, 0x16, 0xf6, 0xf3, 0x5d, 0x1b, 0x08, 0xa2, 0x22, 0x63, 0xd3, 0x51, 0x67, 0x88, 0x1d, 0xf7,
    0xc3, 0x02, 0x03, 0x01, 0x00, 0x01, 0xa3, 0x53, 0x30, 0x51, 0x30, 0x1d, 0x06, 0x03, 0x55, 0x1d,
    0x0e, 0x04, 0x16, 0x04, 0x14, 0x98, 0xdf, 0xa6, 0x19, 0xc1, 0x5c, 0xd7, 0xa7, 0xcc, 0x41, 0x64,
    0xb3, 0x0d, 0xad, 0x31, 0xab, 0x96, 0x5f, 0x7d, 0x11, 0x30, 0x1f, 0x06, 0x03, 0x55, 0x1d, 0x23,
    0x04, 0x18, 0x30, 0x16, 0x80, 0x14, 0x98, 0xdf, 0xa6, 0x19, 0xc1, 0x5c, 0xd7, 0xa7, 0xcc, 0x41,
    0x64, 0xb3, 0x0d, 0xad, 0x31, 0xab, 0x96, 0x5f, 0x7d, 0x11, 0x30, 0x0f, 0x06, 0x03, 0x55, 0x1d,
    0x13, 0x01, 0x01, 0xff, 0x04, 0x05, 0x30, 0x03, 0x01, 0x01, 0xff, 0x30, 0x0d, 0x06, 0x09, 0x2a,
    0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01, 0x0b, 0x05, 0x00, 0x03, 0x82, 0x01, 0x01, 0x00, 0x5b,
    0x50, 0x11, 0x4e, 0x4f, 0xd9, 0x5f, 0x29, 0x13, 0xcd, 0x27, 0x64, 0x1c, 0xf9, 0x09, 0x77, 0x30,
    0x53, 0x67, 0xbe, 0x3f, 0xe7, 0x7d, 0xda, 0x80, 0x57, 0x52, 0x5f, 0xb5, 0x13, 0x41, 0xfe, 0x5f,
    0xf4, 0xeb, 0xea, 0x3d, 0x4f, 0x46, 0xe4, 0x03, 0x52, 0xcf, 0x63, 0x83, 0x1d, 0x84, 0x69, 0x57,
    0x0b, 0x6b, 0x00, 0x19, 0xa6, 0x35, 0x01, 0x76, 0x21, 0x40, 0x65, 0xdb, 0x26, 0x17, 0x8d, 0xdb,
    0x9a, 0x3f, 0xaf, 0xb6, 0x4c, 0xdd, 0xd6, 0x43, 0x73, 0x7c, 0x10, 0xc8, 0x0b, 0x4c, 0x3c, 0x5f,
    0xa3, 0xcd, 0x0d, 0x9c, 0x51, 0x95, 0xbe, 0x9f, 0xd0, 0xa0, 0xcf, 0x7b, 0xd0, 0x7c, 0xc0, 0x4e,
    0x38, 0xac, 0xb5, 0x7b, 0x6a, 0x2b, 0xec, 0x16, 0xe9, 0x55, 0xc0, 0xf3, 0xe6, 0x8a, 0xfd, 0x35,
    0x43, 0x05, 0x3f, 0x8d, 0x40, 0xa0, 0x40, 0x41, 0xa4, 0x58, 0x61, 0xea, 0x35, 0x80, 0xe4, 0x31,
    0x23, 0xe6, 0xf9, 0x4b, 0x1b, 0x54, 0xac, 0xad, 0xea, 0x27, 0xee, 0x4f, 0x1a, 0x52, 0x36, 0xa7,
    0xe1, 0xbb, 0x3b, 0x1c, 0x18, 0x75, 0x9e, 0x5c, 0x61, 0xf6, 0xfb, 0x86, 0xe8, 0xfc, 0xc0, 0xf9,
    0x5a, 0x7a, 0xf7, 0x1e, 0xf2, 0xa3, 0xbe, 0x96, 0x75, 0x03, 0x87, 0x65, 0x37, 0x80, 0x68, 0x9d,
    0x15, 0x68, 0x2a, 0xa0, 0xe7, 0x40, 0x50, 0x27, 0x11, 0x25, 0x9f, 0x97, 0xc5, 0xd0, 0xec, 0xde,
    0x8a, 0xc5, 0x30, 0x5e, 0xad, 0x4b, 0x81, 0xf5, 0x37, 0x40, 0xe6, 0x17, 0x1b, 0xc3, 0xe7, 0xd8,
    0x8c, 0x27, 0x6e, 0xd0, 0xbe, 0x2b, 0x08, 0x3c, 0xe7, 0xf1, 0x3b, 0xb5, 0x99, 0x64, 0x4a, 0xb3,
    0x03, 0xad, 0xfe, 0xb0, 0x59, 0x5a, 0x7d, 0x7d, 0xbe, 0x10, 0x65, 0x30, 0x11, 0x91, 0xe0, 0x2d,
    0xde, 0x70, 0x76, 0xc9, 0xc9, 0xeb, 0x74, 0x7e, 0x64, 0x40, 0xfa, 0x61, 0x1c, 0x0d, 0x9a,
];
const RSA_PSS_RSAE_SHA256_KEY: [u8; 256] = [
    0x09, 0x42, 0xa3, 0x70, 0xd4, 0xe9, 0x35, 0x05, 0x4f, 0x14, 0xa8, 0xda, 0xa2, 0x10, 0x0f, 0x06,
    0x0f, 0x5b, 0x9a, 0x96, 0xb2, 0x0f, 0x9d, 0xad, 0xec, 0xa6, 0x5c, 0x1c, 0x9d, 0x05, 0x1c, 0xb3,
    0x7b, 0x54, 0x7c, 0xab, 0x73, 0xa6, 0xeb, 0xb7, 0x3d, 0xc5, 0xfe, 0x0b, 0xed, 0x1c, 0xf2, 0x8e,
    0x36, 0xdb, 0x81, 0x6b, 0x9c, 0x1c, 0x1f, 0xdc, 0x8f, 0x97, 0xa6, 0x10, 0x46, 0x32, 0x77, 0x83,
    0x5d, 0x00, 0xf1, 0xd6, 0x59, 0x6f, 0x1f, 0x39, 0xdf, 0xdf, 0xa4, 0xa1, 0x0b, 0xba, 0x60, 0x15,
    0xd8, 0x75, 0xbe, 0xf5, 0xcf, 0x49, 0xee, 0xfe, 0x01, 0xc5, 0x94, 0x2b, 0x2a, 0x54, 0x93, 0x91,
    0x3b, 0xec, 0xaf, 0x66, 0x6f, 0xce, 0x25, 0xa2, 0x83, 0x7b, 0x7b, 0x88, 0x81, 0x84, 0xe0, 0xcf,
    0xc8, 0xb6, 0x8c, 0xb2, 0x45, 0xb7, 0x0b, 0xa6, 0x37, 0xa7, 0x5f, 0x20, 0x86, 0x32, 0x64, 0x2b,
    0xf4, 0x75, 0xeb, 0x18, 0xb4, 0x27, 0x52, 0x72, 0x26, 0x1d, 0x3a, 0xc3, 0xde, 0xf4, 0x2e, 0x9f,
    0x91, 0xdc, 0x03, 0xe2, 0x27, 0x81, 0xc0, 0xba, 0x3a, 0xf0, 0xac, 0xd3, 0x4d, 0xf4, 0x8f, 0x62,
    0x82, 0xfe, 0x76, 0x17, 0x19, 0x6c, 0xec, 0xc5, 0xc1, 0x11, 0x29, 0xd2, 0x91, 0x39, 0xf5, 0x28,
    0x26, 0x24, 0xb1, 0x38, 0x23, 0x59, 0x6e, 0x8c, 0xfd, 0x9a, 0xa7, 0x6e, 0x6b, 0x14, 0xe1, 0x88,
    0xab, 0x6c, 0x50, 0x64, 0xf5, 0xe6, 0xdb, 0xaf, 0xcb, 0x11, 0x5d, 0x04, 0xe7, 0x91, 0xde, 0x4e,
    0x8d, 0x78, 0x2d, 0x1e, 0x7c, 0x78, 0x4a, 0x50, 0x8f, 0x9a, 0x7a, 0xf2, 0xcc, 0xb7, 0x36, 0xd4,
    0x4b, 0x86, 0x2c, 0x7a, 0x60, 0xe4, 0xcf, 0x7c, 0x7c, 0x7a, 0x10, 0x65, 0xd3, 0xe2, 0x7d, 0x76,
    0xb9, 0x4e, 0xf9, 0x2c, 0x5b, 0x1d, 0x09, 0x6c, 0x1a, 0x09, 0x35, 0x69, 0x81, 0x2e, 0x0f, 0x71,
];

static response : &str = "HTTP/1.1 200 OK\r\nDate: Mon, 08 Aug 2022 12:28:53 GMT\r\nServer: Apache/2.2.14 (Win32)\r\nLast-Modified: Wed, 22 Jul 2009 19:15:56 GMT
Content-Length: 88\r\nContent-Type: text/html\r\nConnection: Closed\r\n\r\n<html>\r\n<body>\r\n<h1>Hello from localhost!</h1>\r\n</body>\r\n</html>\r\n\r\n";

pub fn tls13server<Stream>(
    stream: Stream,
    host: &str,
    algorithms: Option<Algorithms>,
) -> Result<(), AppError>
where
    Stream: Read + Write,
{
    let (algorithms, cert, key): (Algorithms, &[u8], &[u8]) = if let Some(algorithms) = algorithms {
        match algorithms.2 {
            SignatureScheme::RsaPssRsaSha256 => (
                algorithms,
                &RSA_PSS_RSAE_SHA256_CERT,
                &RSA_PSS_RSAE_SHA256_KEY,
            ),
            SignatureScheme::EcdsaSecp256r1Sha256 => {
                (algorithms, &ECDSA_P256_SHA256_CERT, &ECDSA_P256_SHA256_Key)
            }
            SignatureScheme::ED25519 => todo!(),
        }
    } else {
        (
            default_algs,
            &ECDSA_P256_SHA256_CERT,
            &ECDSA_P256_SHA256_Key,
        )
    };
    let mut stream = RecordStream::new(stream);

    let ch_rec = stream.read_record()?;

    let db = {
        let sni = Bytes::from(host.as_bytes());

        ServerDB(sni, Bytes::from(cert), SignatureKey::from(key), None)
    };

    let ent_s = {
        let mut entropy = [0u8; 64];
        thread_rng().fill(&mut entropy);

        Entropy::from(&entropy)
    };

    match server_accept(algorithms, db, &ch_rec, ent_s) {
        Err(x) => {
            println!("ServerInit Error {}", x);
            match x {
                INVALID_COMPRESSION_LIST => {
                    stream.write_record(Bytes::from(&[21, 03, 03, 00, 02, 2, 47]))?;
                }
                PROTOCOL_VERSION_ALERT => {
                    stream.write_record(Bytes::from(&[21, 03, 03, 00, 02, 2, 70]))?;
                }
                MISSING_KEY_SHARE => {
                    // alerts here are optional
                    eprintln!("Hello message was missing a key share.");
                }
                _ => unimplemented!("unknown error {}", x),
            }
            Err(x.into())
        }
        Ok((sh, sf, sstate)) => {
            println!("Negotiation Complete");
            stream.write_record(sh)?;
            let ccs_rec = Bytes::from_hex("140303000101");
            stream.write_record(ccs_rec)?;
            stream.write_record(sf)?;
            //println!("Server0.5 Complete");

            let ccs = stream.read_record()?;
            check_ccs_message(&ccs.declassify())?;
            //println!("Got CCS message");
            let cf_rec = stream.read_record()?;
            //println!("Got fin record");
            let sstate = server_read_handshake(&cf_rec, sstate)?;
            println!("Handshake Complete");

            let app_rec = stream.read_record()?;
            let (_, sstate) = server_read(&app_rec, sstate)?;
            println!("Got HTTP Request");

            let http_get_resp = Bytes::from(response.as_bytes());
            let (ap, _sstate) = server_write(app_data(http_get_resp), sstate)?;
            stream.write_record(ap)?;
            println!("Sent HTTP Response: Hello from localhost");

            Ok(())
        }
    }
}

fn check_ccs_message(buf: &[u8]) -> Result<(), TLSError> {
    if buf.len() == 6
        && buf[0] == 0x14
        && buf[1] == 0x03
        && buf[2] == 0x03
        && buf[3] == 0x00
        && buf[4] == 0x01
        && buf[5] == 0x01
    {
        Ok(())
    } else {
        Err(PARSE_FAILED)
    }
}
