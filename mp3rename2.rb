# 「アルバム名」のフォルダが作成されていることが前提
# 「アーティスト名」のフォルダを作成し、「アルバム名」フォルダをそこへ移動する
# 移動元パスと移動先パスは別にすること
# ex)
#  sudo ruby mp3rename2.rb /mnt/c/tmp/from /mnt/c/tmp/to

require 'mp3info'
require 'find'
require 'fileutils'

# 「アルバム名」フォルダが有るパス
fromPath = ARGV[0]

# 「アーティスト名」フォルダを作るパス
toPath = ARGV[1]

Find.find(fromPath) do |item|

	if FileTest.directory?(item) then
		
		next if item == fromPath  # 自身はスキップ

		dirNm = File.basename(item)

		artNm = "none"

		# アーティスト名 取得
		Find.find(fromPath + '/' + dirNm) do |mp3File|

			fileNm = File.basename(mp3File)

			next if dirNm == fileNm # 自身はスキップ

			mp3 = Mp3Info.open(fromPath + '/' + dirNm + '/' + fileNm)
			
			artNm = mp3.tag['artist'] # アーティスト名取得

			if artNm.nil? then
				artNm = "none"
			end
			
			break
			
		end

		# 特定文字を削除
		artNm.delete!("'")
		artNm.delete!("?")
		artNm.delete!(":")
		artNm.delete!("/")
		artNm.delete!(".")
		
		# フォルダ作成
		folderPath = toPath + '/' + artNm + '/'
		if Dir.exist?(folderPath) == false then
			Dir.mkdir(folderPath)
		end
	
		# ファイル移動
		FileUtils.cp_r(fromPath + '/' + dirNm, folderPath + dirNm)
		
	end
	
end