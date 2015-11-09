require "message_file"

describe MessageFile do
  it "base 64 encodes the contents" do
    expect(MessageFile.encode("foo bar")).to eq "Zm9vIGJhcg==\n"
  end

  it "decodes base 64 encoded contents" do
    expect(MessageFile.decode("Zm9vIGJhcg==\n")).to eq "foo bar"
  end
end
