#include "connect.h"

tcpConnect::tcpConnect(){
  asio::io_service io_service;
  ip::tcp::socket sock(io_service);

  ip::tcp::resolver resolver(io_service);
  ip::tcp::resolver::query query("localhost","10500");

  ip::tcp::endpoint endpoint(*resolver.resolve(query));

  sock.connect(endpoint);
  
  asio::streambuf buffer;
  boost::system::error_code error;
  asio::read(sock,buffer,asio::transfer_all(),error);
  if(error && error != asio::error::eof)cout<<"SHIPPAI fuee:"<<error.message()<<endl;
  else cout<<&buffer;
}
