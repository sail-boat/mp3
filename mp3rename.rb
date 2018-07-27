# mp3ファイルのファイル名を「トラック番号- タイトル」に変更

require 'mp3info'
require 'find'
require 'fileutils'

path = ARGV[0] ? ARGV[0] : '.' # 引数より対象フォルダパス取得

Find.find(path) do |item|
	if File.extname(item) == '.mp3' then
		fileNm = File.basename(item)
		
		mp3 = Mp3Info.open(path + '/' + fileNm)
		trkNum = mp3.tag['tracknum'] # トラック番号取得
		trkNum = format("%02d", trkNum)  # 頭0埋め
		title = mp3.tag['title'] # タイトル取得

		# 特定文字を削除
		title.slice!("'")
		title.slice!("?")		

		FileUtils.mv(path + '/' + fileNm, path + '/' + trkNum + '- ' + title + '.mp3')
	end
end