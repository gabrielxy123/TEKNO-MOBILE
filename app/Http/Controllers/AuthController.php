<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class AuthController extends Controller
{
    public function register(Request $request){
        $data = $request->validate([
            'name' => ['required', 'string'],
            'email'=> ['required', 'email', 'unique:users'],
            'password'=> ['required', 'min:6'],
        ]);

        $user = User::create($data);

        return response()->json([
            'user' => $user,
            'message' => 'Registrasi sukses'
        ], 201);
    }

    public function login(Request $request) {
        // Validasi input
        Validator::make($request->all(), [
            'email' => 'required|email|exists:users,email',
            'password' => 'required|min:6',
        ])->validate();
    
        // Ambil input
        $email = $request->input('email');
        $password = $request->input('password');
    
        // Verifikasi kredensial
        if (!Auth::attempt(['email' => $email, 'password' => $password])) {
            return response()->json([
                'errors' => 'Invalid Credentials',
            ], 400);
        }
    
        // Ambil user dan buat token
        $user = User::where('email', $email)->first();
        $token = $user->createToken('auth_token')->plainTextToken;
    
        // Return user dan token
        return response()->json([
            'user' => $user,
            'token' => $token,
        ], 200);
    }
    

    public function index()
    {
        $user = User::all();
        return response()->json([
            'status' => true,
            'message' => 'Data berhasil ditemukan',
            'data'=> $user
        ]);
    }

    public function show(string $id){
        $user = User::findorFail($id);
        return response()->json([
            'status' => true,
            'message' => 'Data berhasil ditemukan',
            'data' => $user
        ]);
    }
}
