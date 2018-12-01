class Slime
  # オブジェクトの変数（値）
  attr_accessor :type, :hp, :power

  # 初期化用の特別なメソッド
  def initialize
    self.type = 'スライム'
    self.hp = 10
    self.power = 3
  end

  # オブジェクトのメソッド（処理）
  def attack(character_name)
    puts "#{self.type}が#{character_name}を攻撃して#{self.power}ポイントのダメージを与えた！"
  end
end

slime_A = Slime.new

slime_A.attack('主人公')

p slime_A.class