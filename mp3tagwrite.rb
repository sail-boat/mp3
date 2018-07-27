# mp3ファイルのファイル名からトラック番号などのタグ情報を記入
# ファイル名: {トラック番号}-{アーティスト名}-{曲名}.mp3
 
require 'mp3info'
require 'find'
require 'fileutils'

path = ARGV[0] ? ARGV[0] : '.' # 引数より対象フォルダパス取得
albumNm = ARGV[1] ? ARGV[1] : '' # 引数よりアルバム名取得

Find.find(path) do |item|
	if File.extname(item) == '.mp3' then
		fileNm = File.basename(item)

		# ファイル名分解
		tmpFileNm = fileNm.sub(/\.mp3/, "")
		#tmpFileNm = fileNm.delete("mp3") # deleteは文字列ではなく文字で削除してしまう
		splitFileNm = tmpFileNm.split("-")

		splitFileNm.each do |data|
			if data.empty? then
				data = "nil"
			else
				data.strip!
			end
		end

		Mp3Info.open(item) do |mp3|
			mp3.tag2.TIT2 = splitFileNm[2] # タイトル
			mp3.tag.TT2 = splitFileNm[2] # タイトル
			mp3.tag2.TPE1 = splitFileNm[1] # アーティスト
			mp3.tag.TP1 = splitFileNm[1] # アーティスト
			mp3.tag2.TALB = albumNm # アルバム名
			mp3.tag.TAL = albumNm # アルバム名
			#mp3.tag2.TYER = # 年
			#mp3.tag.TYE = # 年
			mp3.tag2.TRCK = splitFileNm[0] # トラック番号
			mp3.tag.TRK = splitFileNm[0] # トラック番号
			#mp3.tag2.TCON = # ジャンル名
			#mp3.tag.TCO = # ジャンル名

		end
	end
end