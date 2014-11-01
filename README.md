#AVAWSW

Analyze Voice - Analyze Words - Speak Words Systems in  TeddyBear 

##使い方

1. move to Your julius directry
2. run julius on TCP/IP mode 
4. run julius_receive.rb

##処理の仕組み

###使っているもの

* [Julius](julius.sourceforge.jp)
* [docomo雑談対話API](https://dev.smt.docomo.ne.jp/?p=docs.api.page&api_docs_id=3)
* [OpenJTalk](http://open-jtalk.sourceforge.net/)

今回のシステムは、主に *音声解析*,*返答生成*.*返答音声生成*の３つの要素にわかれます。

###音声解析

音声解析は、大語彙連続音声認識エンジンであるJuliusの、サーバーモード(TCP/IP)を利用しています。
音声解析のデータはXMLで送信されるため、そのXMLをRubyを利用して解析しています。
解析して得られた文章を返答生成システムに送ります。

###返答生成

返答生成は、2つの方法を利用しています。

* CSV型返答登録システム
* ドコモ雑談対話API

まずCSV型返答登録システムに登録されている言葉が、送られてきた文章に含まれているかを確かめます。
もしも含まれていた場合は、その言葉に登録されていた返答を返答音声生成システムにおくります。
もし含まれていなかった場合は、ドコモの雑談対話APIにリクエストを送り、その結果を返答音声生成システムに送ります。
ただここで、ドコモのAPIがあまりにも文字数の多い返答を返してきた場合は、その返答を無視する設定となっています。

###返答音声生成

送られてきた文字列をspeak.txtに書き込みます。
その後open-jtalkを利用してその返答の文字列から音声を生成します。
その後、mplayerを利用して、音声を再生します。
ここまでの処理は、Rubyで記述することが困難なため、シェルスクリプトに記述しました。

