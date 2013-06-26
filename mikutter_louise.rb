# -*- coding: utf-8 -*-

Plugin.create(:mikutter_louise) do
  command(
          :mikutter_louise,
          name: 'ルイズ',
          condition: -> _ { true },
          visible: true,
          role: :timeline
          ) do
    
    require 'MeCab'

    #f = open("./ruis.txt")
    #text = f.read
    #f.close

    text = "ルイズ！ルイズ！ルイズ！ルイズぅぅうううわぁああああああああああああああああああああああん！！！
あぁああああ…ああ…あっあっー！あぁああああああ！！！ルイズルイズルイズぅううぁわぁああああ！！！
あぁクンカクンカ！クンカクンカ！スーハースーハー！スーハースーハー！いい匂いだなぁ…くんくん
んはぁっ！ルイズ・フランソワーズたんの桃色ブロンドの髪をクンカクンカしたいお！クンカクンカ！あぁあ！！
間違えた！モフモフしたいお！モフモフ！モフモフ！髪髪モフモフ！カリカリモフモフ…きゅんきゅんきゅい！！
小説12巻のルイズたんかわいかったよぅ！！あぁぁああ…あああ…あっあぁああああ！！ふぁぁあああんんっ！！
アニメ2期放送されて良かったねルイズたん！あぁあああああ！かわいい！ルイズたん！かわいい！あっああぁああ！
コミック2巻も発売されて嬉し…いやぁああああああ！！！にゃああああああああん！！ぎゃああああああああ！！
ぐあああああああああああ！！！コミックなんて現実じゃない！！！！あ…小説もアニメもよく考えたら…
ル イ ズ ち ゃ ん は 現実 じ ゃ な い？にゃあああああああああああああん！！うぁああああああああああ！！
そんなぁああああああ！！いやぁぁぁあああああああああ！！はぁああああああん！！ハルケギニアぁああああ！！
この！ちきしょー！やめてやる！！現実なんかやめ…て…え！？見…てる？表紙絵のルイズちゃんが僕を見てる？
表紙絵のルイズちゃんが僕を見てるぞ！ルイズちゃんが僕を見てるぞ！挿絵のルイズちゃんが僕を見てるぞ！！
アニメのルイズちゃんが僕に話しかけてるぞ！！！よかった…世の中まだまだ捨てたモンじゃないんだねっ！
いやっほぉおおおおおおお！！！僕にはルイズちゃんがいる！！やったよケティ！！ひとりでできるもん！！！
あ、コミックのルイズちゃああああああああああああああん！！いやぁあああああああああああああああ！！！！
あっあんああっああんあアン様ぁあ！！シ、シエスター！！アンリエッタぁああああああ！！！タバサｧぁあああ！！
ううっうぅうう！！俺の想いよルイズへ届け！！ハルケギニアのルイズへ届け！"

    # mecabで形態素解析して、 参照テーブルを作る マルコフ連鎖で要約
    mecab = MeCab::Tagger.new("-Owakati")
    
    data = Array.new
    mecab.parse(text + "EOS").split(" ").each_cons(3) do |a|
      data.push h = {'head' => a[0], 'middle' => a[1], 'end' => a[2]}
    end
    
    t1 = data[0]['head']
    t2 = data[0]['middle']
    new_text = t1 + t2
    
    while true
      _a = Array.new
      data.each do |hash|
        _a.push hash if hash['head'] == t1 && hash['middle'] == t2
      end
      
      break if _a.size == 0
      num = rand(_a.size) # 乱数で次の文節を決定する
      break if _a[num]['end'] == "EOS"
      sn = _a[num]['end'].size
      break if (new_text.size + sn)/3 > 140
      # print _a[num]['end'],"\n"
      new_text = new_text + _a[num]['end']
      t1 = _a[num]['middle']
      t2 = _a[num]['end']
    end

    # puts new_text
    Post.primary_service.update(message: new_text)
    end

end
